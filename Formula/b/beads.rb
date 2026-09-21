class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/gastownhall/beads"
  url "https://github.com/gastownhall/beads/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "849f8b3c8d4e80d170ddef052b732baceb6f28c378edb106dcb097245367849c"
  license "MIT"
  compatibility_version 1
  head "https://github.com/gastownhall/beads.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f056254428086b36ae36c17c7676006ac4a14e9dcc3171e3de607cb8579d71bd"
    sha256 cellar: :any, arm64_tahoe:       "ef3f72dde113b8a3a3447f4f495b52a18765438ae871745dadd305112ab44c23"
    sha256 cellar: :any, arm64_sequoia:     "d5cc986f8306f6ed944ae4f304d2530dfe4063f85ecfb4047dad430adf431c06"
    sha256 cellar: :any, arm64_linux:       "318cc0db07f17fbbc7f83af443415bc5d25e69121b011c9cb46c427be6e646cc"
    sha256 cellar: :any, x86_64_linux:      "01a7344c33d0837cdf8a5b652690020d51b8211f36a2edf253df86b78b7e9a3e"
  end

  depends_on "go" => :build
  depends_on "dolt"
  depends_on "icu4c@78"

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
