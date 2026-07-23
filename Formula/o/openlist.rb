class Openlist < Formula
  desc "New AList fork addressing anti-trust issues"
  homepage "https://doc.oplist.org/"
  url "https://github.com/OpenListTeam/OpenList/archive/refs/tags/v4.2.4.tar.gz"
  sha256 "4ed48156664ad046dd18e1da994354ecd2791508655a9b12c493142784b46511"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "773ba1e1ae7065540baab9126eca73d1d5d6c5a0426eaee448c8e7106d104be4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "756d2bbd3700b85de4f486b36dc648146930962f2006efa7ca65cd8b73573d3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbf690ee3a568c191d18a3335f9162e24e8c2ca95ee597a56e4ed7bd81281ad3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dad0e3a405c1983feb9caa8b9dc13015e8d62cb1004dda72dc268ad94c59717"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e493d4bbf8e69b9c33824ccdb512549fe2e3425d0ba3bba31f9cb5c9d220db6"
    sha256 cellar: :any,                 x86_64_linux:  "05c3fd73e3ad679fd62b01555a3b9244cf3947af154fc516ab33a320a66f3198"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  on_linux do
    depends_on "sqlite" => :build
  end

  resource "frontend" do
    url "https://github.com/OpenListTeam/OpenList-Frontend/archive/refs/tags/v4.2.4.tar.gz"
    sha256 "751dbd39002ce21a0f20189967da232fcea99f0d87d17593c18a1d065145986a"

    livecheck do
      formula :parent
    end
  end

  resource "i18n" do
    url "https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v4.2.4/i18n.tar.gz"
    sha256 "f969170b947a185baef431dc6dabcfd90ed3826b535438661fdf84d6d076a38b"

    livecheck do
      formula :parent
    end
  end

  def install
    resource("i18n").stage buildpath/"i18n"

    resource("frontend").stage do
      cp_r Dir[buildpath/"i18n/*"], Pathname.pwd/"src/lang"

      system "pnpm", "with", "current", "install"
      system "pnpm", "with", "current", "build"
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
