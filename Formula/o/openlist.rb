class Openlist < Formula
  desc "New AList fork addressing anti-trust issues"
  homepage "https://doc.oplist.org/"
  url "https://github.com/OpenListTeam/OpenList/archive/refs/tags/v4.2.10.tar.gz"
  sha256 "4e45a675ee4719a98038a64f0f2095bd82146bb7342466f42d2407f5d3e701f7"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b30566adb51646b950303415de9ee1ac83c70cc58a9518c1136b959023862e42"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b2c25f479c5456453487bfcf4e2b3ef1afb08bd4837339ad9453e947d804d3a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bb5af0645130b68e721b2c797fa15a2f8684b569b69c66886ea6575406a0603f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6fec4464fe306639e132d46694c38a3316ad04b0254b7ec5d0362fa93bd3928d"
    sha256 cellar: :any,                 x86_64_linux:      "98b1da5a0a14e18d4bd7b6e6ef867be417c62083d8a7caa2f1d9195053e59118"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  on_linux do
    depends_on "sqlite" => :build
  end

  resource "frontend" do
    url "https://github.com/OpenListTeam/OpenList-Frontend/archive/refs/tags/v4.2.10.tar.gz"
    sha256 "b847ca699a497efd43b8c2b512bb278e7c36466cf3f49be809797eb3a8b1de9f"

    livecheck do
      formula :parent
    end
  end

  resource "i18n" do
    url "https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v4.2.10/i18n.tar.gz"
    sha256 "f442b6de2f636407d7eb7bfb22525ff9f9be55cc2ff0706ada5b12bf432030e8"

    livecheck do
      formula :parent
    end
  end

  allow_network_access! :test

  def fetch
    resource("frontend").stage do
      system "pnpm", "with", "current", "fetch"
    end
    system "go", "mod", "download"
  end

  def install
    resource("i18n").stage buildpath/"i18n"

    resource("frontend").stage do
      cp_r Dir[buildpath/"i18n/*"], Pathname.pwd/"src/lang"

      system "pnpm", "--offline", "with", "current", "install"
      system "pnpm", "with", "current", "build"
      cp_r Pathname.pwd/"dist", buildpath/"public"
    end

    ldflags = %W[
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
