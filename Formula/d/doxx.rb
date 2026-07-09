class Doxx < Formula
  desc "Terminal document viewer for .docx files"
  homepage "https://bgreenwell.github.io/doxx/"
  url "https://github.com/bgreenwell/doxx/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "72af676ca30b27adc7a13b17a48aac88589c940accba28453f3d94a861bed961"
  license "MIT"
  head "https://github.com/bgreenwell/doxx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6be0a3aa1a03e30b38cb28427107453bcb32129ab15b54f5532ca9101ee3c177"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fe939787e7e4ef12201afd9c362ae7ae9f94b3e060c7ad7bbec0937a5702d5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "068b83c66b43c33997dfd0669cb170d476a707d64510e23cb143117afba3243d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e993e41817de2f241127a11f5ce599acca6dc725049a02af141d2724fd1a867f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9698760fceae5df8da6e88f7856d3e43b8a636a920191dbbc0ac5b3088e40789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5551f74f41a521804764a0dc823515a94681b63c13663e03583680df2432b14d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"generate_test_docs"
    assert_path_exists testpath/"tests/fixtures/minimal.docx"

    output = shell_output("#{bin}/doxx #{testpath}/tests/fixtures/minimal.docx")
    assert_match <<~EOS, output
      Document: minimal
      Pages: 1
      Words: 26
    EOS
  end
end
