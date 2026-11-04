class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/gastownhall/beads"
  url "https://github.com/gastownhall/beads/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "450284d684e9b114a59ea60afb578dbdca40b2e5307d2c349a9ec37760409c46"
  license "MIT"
  compatibility_version 1
  head "https://github.com/gastownhall/beads.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ba2129f19503bf7b63922f0d5c5b9034baeaf1cc486186396f4222f2e9213138"
    sha256 cellar: :any, arm64_tahoe:       "2ed14f6ff6943f94f316430e2a961ce8563d91ee73ad8e57065896e615409e4a"
    sha256 cellar: :any, arm64_sequoia:     "2d17797d55bdedf30ba83cb116971c157794731c342aab9cd9492f1e8c84c397"
    sha256 cellar: :any, arm64_linux:       "786adb667a90e1f84f63af1a0e821d51bcaa45f2c21771849fab59e9133dc3b1"
    sha256 cellar: :any, x86_64_linux:      "ec8f032780704bbdc0ef6b50c7e36a18b50984bc94f2c7b346783bec5c9e0c28"
  end

  depends_on "go" => :build
  depends_on "dolt"
  depends_on "icu4c@79"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    if OS.linux? && Hardware::CPU.arm64?
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = %W[
      -X main.Version=#{version}
      -X main.Build=#{tap.user}
      -X main.Branch=#{build.head? ? "HEAD" : "v#{version}"}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/bd"
    bin.install_symlink "beads" => "bd"

    generate_completions_from_executable(bin/"bd", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bd --version")

    system bin/"bd", "init", "--prefix", "homebrew-beads", "--non-interactive", "--stealth"
    system bin/"bd", "setup", "claude"
    assert_path_exists testpath/"CLAUDE.md"
    assert_path_exists testpath/".beads/config.yaml"

    output = shell_output("#{bin}/bd --db #{testpath}/.beads/dolt info")
    assert_match "Beads Database Information", output
    assert_match "Issue Count: 0", output
  end
end
