class Openlist < Formula
  desc "New AList fork addressing anti-trust issues"
  homepage "https://doc.oplist.org/"
  url "https://github.com/OpenListTeam/OpenList/archive/refs/tags/v4.1.8.tar.gz"
  sha256 "8ba861db0ad29e60fcfb4544ff3744dfa235ab1744ea0c998e1c6f80a630996d"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2f7268bdf7cc74cd2b6d5106c24b624e4d74fa0a6be4d05268baa9420c9fa6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "609304072300fe7808cf53fc7634a3e79b84ea59187f78d3965f100e91f34dd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74fd740af36b85ad14ab0841807d951f32704037d9bc665478ee691f76eb959d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b70b096997004034dcd47a1dbbd65fbc096ca30da8cf40e30bf23c9b3b8488ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c25d06885c7072e80be39c156a15701772eb822edf2c395319d91888147fba12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12eb6b166e988e5f857008ba66f81c9bdea3e90f53b1990ea50ed3362efc98f2"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  on_linux do
    depends_on "sqlite" => :build
  end

  resource "frontend" do
    url "https://github.com/OpenListTeam/OpenList-Frontend/archive/refs/tags/v4.1.8.tar.gz"
    sha256 "83ed50798f3a58b5ae0a00b469860cb19a7644bc701591cbd34e99fe4b5600af"

    livecheck do
      formula :parent
    end
  end

  resource "i18n" do
    url "https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v4.1.8/i18n.tar.gz"
    sha256 "7ff3a9106ac6af3bb46f785f55104bae9ac01880d8c235cf1cd2dfc8295381c1"

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
