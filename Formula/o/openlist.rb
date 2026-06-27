class Openlist < Formula
  desc "New AList fork addressing anti-trust issues"
  homepage "https://doc.oplist.org/"
  url "https://github.com/OpenListTeam/OpenList/archive/refs/tags/v4.2.2.tar.gz"
  sha256 "4f630caffb625bfd8a8c6bd9f798f7b36bd6147932a450c0b9f6e3ac2979fdbe"
  license "AGPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25457e13ee6052ee325bd79f7777b6e2d7bc19dc3952575ac1432c32e1e19548"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0446065512ecab91224b5a1c56c20ab4fe4b350d8308ef745b2faf76375bcbaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ad59fb944e46cacd494af5419c8081d6c591c4d5d114bb8030f87e0362b24b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "400b81c28d4dac42d4af5866802d92a67b12f69dbf8989252167d920d5bc99ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81fd500cfd6b7d13177c491d7c3a6375784e03a9797ebfb927022c7041d6d178"
    sha256 cellar: :any,                 x86_64_linux:  "8459c09605ec10c29ecad12ed92d23b63192728e2140050fcc8e2246ef44a0dd"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  on_linux do
    depends_on "sqlite" => :build
  end

  resource "frontend" do
    url "https://github.com/OpenListTeam/OpenList-Frontend/archive/refs/tags/v4.2.2.tar.gz"
    sha256 "361354a219d4c31e42933fd6423d56e740184ae0b709440a1df1f368f13474fb"

    livecheck do
      formula :parent
    end
  end

  resource "i18n" do
    url "https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v4.2.2/i18n.tar.gz"
    sha256 "519bf24349c9bac9078840a9b744fcf744492cf2b4ef0ae6445fc6eab888f79a"

    livecheck do
      formula :parent
    end
  end

  def install
    resource("i18n").stage buildpath/"i18n"

    resource("frontend").stage do
      cp_r Dir[buildpath/"i18n/*"], Pathname.pwd/"src/lang"

      system "pnpm", "install"
      system "pnpm", "build"
      cp_r Pathname.pwd/"dist", buildpath/"public"
    end

    ldflags = %W[
      -s -w
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.BuiltAt=#{time.iso8601}
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.GoVersion=#{Formula["go"].version}
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.GitAuthor=#{tap.user}
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.GitCommit=#{tap.user}
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.Version=#{version}
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.WebVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/openlist help")
    assert_match(/Version: #{version}/, shell_output("#{bin}/openlist version"))

    test_data_dir = testpath/"data"
    pid = Process.spawn(bin/"openlist", "server", "--data", test_data_dir)

    max_attempts = 10
    attempt = 0
    http_status = "000"

    while attempt < max_attempts
      sleep 3
      http_status = shell_output("curl -s -o /dev/null -w '%<http_code>s' http://127.0.0.1:5244/ 2>&1").strip

      break if http_status != "000" && http_status != "000s"

      attempt += 1
    end

    if pid
      Process.kill("TERM", pid)
      Process.wait(pid)
    end

    refute_equal "000", http_status
  end
end
