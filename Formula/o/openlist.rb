class Openlist < Formula
  desc "New AList fork addressing anti-trust issues"
  homepage "https://doc.oplist.org/"
  url "https://github.com/OpenListTeam/OpenList/archive/refs/tags/v4.2.2.tar.gz"
  sha256 "4f630caffb625bfd8a8c6bd9f798f7b36bd6147932a450c0b9f6e3ac2979fdbe"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d08f0758882ecf99e8665ad7e55638605f52c0148773155883d7418ca0b6e4b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcb7708943100948b4be9a6b993104c6785da13047b0a0f12922df44122573a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4971443aa99a8b780b82edb2a1bc71c50e906e24460aef7d0282e53fa3de4d49"
    sha256 cellar: :any_skip_relocation, sonoma:        "2be6bf62c280d567b5f66038f17daa80cfb472a920921c49467e46155f2f6206"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb69c55d46b91fcc4f4d205513e842785351106f17973b79c89592a4abf157b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d5ef8dc97e97797ea5f8a37621fd50c0658943d096e261e241b144cfe3238ed"
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
      cp_r buildpath/"i18n", Pathname.pwd/"src/lang"

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
