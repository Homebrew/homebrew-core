class Lazydocker < Formula
  desc "Lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker.git",
      tag:      "v0.18.1",
      revision: "da650f4384219e13e0dad3de266501aa0b06859c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af70f10f71973bb0bbd6665cf602aebfc47634d3a670c40f3d15b622aa15ea72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54f1a83221eb432bd7e7f330c00eafe70c71f4759490b37a308755ccfd074cad"
    sha256 cellar: :any_skip_relocation, monterey:       "69a031056124ed0abf55e64ff94e18cd8270c8e3e11e8d1d5e61a5b12294ca3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "05a646c55aaa9aac0efbc51a13253036c5acf030dc6184d0bd7af311c68b5752"
    sha256 cellar: :any_skip_relocation, catalina:       "faf25d87b0e80f10c109ce55d8f1d332786ef2ae98dd9871d99864f488be7118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6e2024d69df4df7a28f75aebd7b9e5db1d6002b1d500276fa5e258618422637"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", bin/"lazydocker",
      "-ldflags", "-X main.version=#{version} -X main.buildSource=homebrew"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydocker --version")

    assert_match "language: auto", shell_output("#{bin}/lazydocker --config")
  end
end
