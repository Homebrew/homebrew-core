class Aichat < Formula
  desc "All-in-one AI-Powered CLI Chat & Copilot"
  homepage "https://github.com/sigoden/aichat"
  url "https://github.com/sigoden/aichat/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "1743534a68acb9fdf4fee11cd2b38cc5282c85debf89a4052b61a09dcaf51185"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sigoden/aichat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75ffbe1df040a3d2e42a54277a149b7df6af3373751c41c5d005d72fd914ed08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "840e7b978728e0e0c124ed58ab394268d8a6eb10eb8a9ce3321a93bf8206cb9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "223161ee04f14f241e747e7ba9a84e755f37fb19c81db601960b9051c053faf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6ad2ef6b370708c75f42877afa6588fd467e29bd91bb899c2c8e6f6cb855d02"
    sha256 cellar: :any_skip_relocation, ventura:       "ba2ef442789befe5d2369d94aefd8a8bc871bd709a11fd98f9afcce8448d2653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b5f85275c516c268ad5cc0c9a3dacaa2b635091afcdf2c05cd78c7c0d0d3e9a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "scripts/completions/aichat.bash" => "aichat"
    fish_completion.install "scripts/completions/aichat.fish"
    zsh_completion.install "scripts/completions/aichat.zsh" => "_aichat"
  end

  test do
    ENV["AICHAT_PLATFORM"] = "openai"
    ENV["OPENAI_API_KEY"] = "sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    output = shell_output("#{bin}/aichat --dry-run math 3.2x4.8")
    assert_match "math 3.2x4.8", output
  end
end
