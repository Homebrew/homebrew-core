class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://github.com/steveyegge/beads/archive/refs/tags/v0.47.2.tar.gz"
  sha256 "0c42194d5fa73cc60a345207f1487121f1390858eeef1e5e376f947f48f0e8e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cf897e0aa7de106b92278a8a46e895497914366701debe4d868b33fbc97c6ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96e40e716898901b2cc15580958fea31eba3966d819435a0e7d1e0fd0e183484"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93b8f36ac40e4466509095fab9245749fcc709dcb268ba3965cf130efebb9ee8"
    sha256 cellar: :any_skip_relocation, sonoma:        "992e9e35c48c6b634e6cad4782f41aeded3a2cdb6472741147e7f38a15a7256a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8eaf420a890f431a38b62f21c271f01d97af0ebbee49de9af3211d6f3c2a24bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dfc3f331a8025d80fb0b1ad5ac71b6428755f87498a14d9a0aea68e5a8eadab"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/bd"
    bin.install_symlink "beads" => "bd"

    generate_completions_from_executable(bin/"bd", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bd --version")

    system "git", "init"

    system bin/"bd", "init"
    assert_path_exists testpath/"AGENTS.md"

    output = shell_output("#{bin}/bd info")
    assert_match "Connected: yes", output
  end
end
