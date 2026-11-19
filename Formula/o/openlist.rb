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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "859e717057ffb2793e08f69f41caae0480481744f1e654a52ac6e15165d66098"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "692c30e84423db9d9f585d9247286a66f59a64901de6434b031395dd83048b90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4defe8bf9506d9b68624933db2193ed4e20df08537f3bec42047223693f8c777"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "17e2a605fc2bed4c77d37c6caf271d51ae2834c77f32d0cc2b46fb92fcc26582"
    sha256 cellar: :any,                 x86_64_linux:      "371046ac995b8a6dfccc3a4f2c23e8460c4c79cef16086f728f197de3d2855c6"
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
