class Openlist < Formula
  desc "New AList fork addressing anti-trust issues"
  homepage "https://doc.oplist.org/"
  url "https://github.com/OpenListTeam/OpenList/archive/refs/tags/v4.1.9.tar.gz"
  sha256 "5171cef3b03f6b68af0e4886af7b6f5a6f9c103de41c3b831f46dcb3ddcc6f18"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da4923c2b652abd3bf260b75cb2f1b21328004088972358e43af7e42adf7a889"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "269f3bc18c63bfb3c926e7219d89a61d9d90ae34a0309364cac328b6e7648b90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7094c270b9fc842216567fe4ecc99a7b6cf593c891dd89676d03a04b2a1e384"
    sha256 cellar: :any_skip_relocation, sonoma:        "b857d1919185b6279a9861a7f8674c5a8adc9adf4174f1164a54ebfa86d38db9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb87dc3a53d86ade81059a4700fd324280ab5bd4d9a49ba3804e6177aacb25d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2da8ab417df37702c29490e1548429d4fc2f379e76dabfaa63bab57f40a8368d"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  on_linux do
    depends_on "sqlite" => :build
  end

  resource "frontend" do
    url "https://github.com/OpenListTeam/OpenList-Frontend/archive/refs/tags/v4.1.9.tar.gz"
    sha256 "fb708699119e96fe59db75d2425101d9c22dd186c89ec590616fd046c3830c40"

    livecheck do
      formula :parent
    end
  end

  resource "i18n" do
    url "https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v4.1.9/i18n.tar.gz"
    sha256 "b7e76f1b8a23a193d70458213cfa897bbd94892fdd05e70317e7d433864afcb0"

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
