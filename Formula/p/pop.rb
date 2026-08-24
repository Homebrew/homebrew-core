class Pop < Formula
  desc "Send emails from your terminal"
  homepage "https://github.com/charmbracelet/pop"
  url "https://github.com/charmbracelet/pop/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "c577d4f3edf403e34832013b79ddc159c1eec938e0bd452b2623c853f752a75c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14e534422878d8bd5f21a115f639daaf9fe0b90f0b81fe8204fc481ec4b25463"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14e534422878d8bd5f21a115f639daaf9fe0b90f0b81fe8204fc481ec4b25463"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14e534422878d8bd5f21a115f639daaf9fe0b90f0b81fe8204fc481ec4b25463"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ff5ac45ee5e933a2c2735a0ddfa214a49f2734b90a24655558db9a94774a375"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "759abf4c656a319cc362fa83cbaec47e3ba3d74036038bf92d120c25f4e53477"
    sha256 cellar: :any,                 x86_64_linux:  "cb685c08066b7924e262f99c717e2531835a177cdbf84bc6f9dacb097a676b5b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}")

    generate_completions_from_executable(bin/"pop", shell_parameter_format: :cobra)
    (man1/"pop.1").write Utils.safe_popen_read(bin/"pop", "man")
  end

  test do
    assert_match " Charm Pop  Hello!",
      shell_output("#{bin}/pop --body 'hi' --subject 'Hello' 2>&1", 1).chomp

    assert_match version.to_s, shell_output("#{bin}/pop --version")
  end
end
