class Openlist < Formula
  desc "New AList fork addressing anti-trust issues"
  homepage "https://doc.oplist.org/"
  url "https://github.com/OpenListTeam/OpenList/archive/refs/tags/v4.2.6.tar.gz"
  sha256 "028694b14ba7368429774f33c1b7eb584b2bf6235fb7d72df371e528a5c6b04c"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "89f320d6b05217c82cb9da9e3b1219a30cb67d81cbbea8c6a8d1a153335162f4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "558f9a9115717cd973d26151ab983af4cf05dda0c1f02ff1e324b02c29d8742b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f0126b6d42c84eb2dea7d05cdae57a917fe73ab5eff8ec9a5bf7aa42e29f1d04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "44edcb3af9b3a8ecb0bc8c9eaa46d2f13d32710c5c49275c99712501f9c4b4e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1c346e22a062a88c903ed18d82041604c2a2f4c064db06c2b37ffaf1e138e7de"
    sha256 cellar: :any,                 x86_64_linux:      "037afac81ed773cb2f5cca80adf079336a6e645c748ab079bb3a4af5a68ba9d7"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  on_linux do
    depends_on "sqlite" => :build
  end

  resource "frontend" do
    url "https://github.com/OpenListTeam/OpenList-Frontend/archive/refs/tags/v4.2.6.tar.gz"
    sha256 "fa613bd495cd7708c22a3c511145e5a517c920eb6067513c74762ca15dfa0f3a"

    livecheck do
      formula :parent
    end
  end

  resource "i18n" do
    url "https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v4.2.6/i18n.tar.gz"
    sha256 "de3160d4a784666002ff632e77c1653bbff32358a81377a1c964e6a29e306556"

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
