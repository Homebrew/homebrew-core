class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://github.com/steveyegge/beads/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "85a9c6185d63eb8a300852947203cf5cdb4926249e3ac7f800a12df0f61d797e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39db5591933e06be23b06c242b2f54af5aa97a642dd6b646e9fc19817156d268"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0de7052063bd2355bf666dd627b73a5155ac5dc228ce29038a829cb2c930c8eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85fef7e00c133f2e68512b162330e50d0f61ae4640f79872ee24a0dfbf98bbb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb44155806e9f6dd44f0031a19af827e7f21fd6879990c25c462598b1980560e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17341b1d00c51c1265ed727a940be37d9723d6b144ebc27808b893a9a7499d40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ef784a8c0acd80856570f61b2b3491548b0971f78aba884285af141c5663bc9"
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
