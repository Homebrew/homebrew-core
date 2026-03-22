class Openlist < Formula
  desc "New AList fork addressing anti-trust issues"
  homepage "https://doc.oplist.org/"
  url "https://github.com/OpenListTeam/OpenList/archive/refs/tags/v4.1.10.tar.gz"
  sha256 "0e85b2e9f97c819a79a054c2de1f505b0b0d78e1c8ce6783e12da85ea519840c"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "435f540dd5c76ee03b1315c8d84efeff51edc21b3f31df2e841226008087d4f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04ec41f119be7b46da4d489a9e3539eb0a252b27069ee1a30c079c209277f5a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f965acb6b8a592fb30b1f02af83dfafd01a88094deec520b39f4e4b6aadf3f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "397b95f8f40afa663ee0746faa0a6f12208c41d78841aae4ba0661359cb63820"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bcbdc6e59f842b464d23478193e73c77bac6d117f8c9d0b8297ddc3a96354b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26b013899c56ef2e1c85b47cddc7eeaf543d2f9170a56ad96b802e06f0d0d8fa"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  on_linux do
    depends_on "sqlite" => :build
  end

  resource "frontend" do
    url "https://github.com/OpenListTeam/OpenList-Frontend/archive/refs/tags/v4.1.10.tar.gz"
    sha256 "30f92e70b8ba99344833f9da99eedc5803459a74236ee5dd3ab275160fe7dd4b"

    livecheck do
      formula :parent
    end
  end

  resource "i18n" do
    url "https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v4.1.10/i18n.tar.gz"
    sha256 "f25ee76ed4d1e270afb2fe0c7d24477ed52a584f0bcc4173acd8fe93524f1d40"

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

    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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
