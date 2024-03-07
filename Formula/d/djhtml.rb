class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/a0/03/aac9bfb7c9b03604a2c4b0d474af22731ef41cb662fad07f956ae7bf0f6b/djhtml-3.0.6.tar.gz"
  sha256 "abfc4d7b4730432ca6a98322fbdf8ae9d6ba254ea57ba3759a10ecb293bc57de"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f415fd277986f7921b153fcd3b56965e2c50a5e843c1909d5b5ae2e5ed8abcbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a099a552f895a3e69363f8d5e8924ea0dfa3a9fc3906781db9b149d204edbba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "227cb26accb4cd99571cd0c87830aa30a3f3869aa63d4f0e81187e1fdc6fde65"
    sha256 cellar: :any_skip_relocation, sonoma:         "76dec41c9b44cf9a07a65cc999dba39a8e8345989e5098e5ec6edf7c73f4f95a"
    sha256 cellar: :any_skip_relocation, ventura:        "2895bd501935f91d058a096f381c513f491c68fc13fad3c913ef9cc1378f7651"
    sha256 cellar: :any_skip_relocation, monterey:       "bce2b9548acf59dff7b5b3303c036bf8cd21b441811056fc7a70ccb5f247348b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb1265169606f5b095a3878b7fdb4e0ff29d0d25d3cd7880af6da73e126732e0"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.html"
    test_file.write <<~EOF
      <html>
      <p>Hello, World!</p>
      </html>
    EOF

    expected_output = <<~EOF
      <html>
        <p>Hello, World!</p>
      </html>
    EOF

    system bin/"djhtml", "--tabwidth", "2", test_file
    assert_equal expected_output, test_file.read
  end
end
