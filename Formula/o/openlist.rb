class Openlist < Formula
  desc "New AList fork addressing anti-trust issues"
  homepage "https://doc.oplist.org/"
  url "https://github.com/OpenListTeam/OpenList/archive/refs/tags/v4.2.3.tar.gz"
  sha256 "3b41170944b5fdbd59a6b1facf438a7f73549de19580858098deb32a797946e3"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18ea563649c76ee98de4c2377be201126929d0de53b2295fdf3f6b5df9c570be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d84d9636b72591781be66775019330be5e6cde86938e15dfc7c139bc5fd038fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17742bb8c6328e7c8d4e8642269dd30b9537247dec6b91575bfb518d7816802f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e5166a84b25164fa16112d2b121224bb7d5a0f095364eb65c1b6c99ba390aec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d66e4addf529a1189fb4a28f4e86b9eae26433426cb297a6d71ded9cb2496ce"
    sha256 cellar: :any,                 x86_64_linux:  "01ae550ea748a2122cec56f16afa2cce62a02439249fd129bb363efcf3a6b6c9"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  on_linux do
    depends_on "sqlite" => :build
  end

  resource "frontend" do
    url "https://github.com/OpenListTeam/OpenList-Frontend/archive/refs/tags/v4.2.3.tar.gz"
    sha256 "ee77391b5ed360885f6bfa3add1645c2841308dce2d7a0befa9625afe1164e80"

    livecheck do
      formula :parent
    end
  end

  resource "i18n" do
    url "https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v4.2.3/i18n.tar.gz"
    sha256 "57949ace6291bf937cdb4b8875203530e6d3286abad8263596f227643cade11b"

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
