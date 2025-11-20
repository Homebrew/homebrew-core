class Dtrx < Formula
  include Language::Python::Virtualenv

  desc "Intelligent archive extraction"
  homepage "https://pypi.org/project/dtrx/"
  url "https://files.pythonhosted.org/packages/0e/41/53459c8452da0f357d55943704ff960dab35c33a068b057a40512faa3e03/dtrx-8.7.0.tar.gz"
  sha256 "d7c58048cd4a0e05337f0e0e01b05ad9ebc2b450a0f6706afc4b69abea81096f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5d20b9765b801e3900f290def6de47f5e32ac38bf43723848e4b03bc6b00a742"
  end

  # Include a few common decompression handlers in addition to the python dep
  depends_on "p7zip"
  depends_on "python@3.14"
  depends_on "xz"

  uses_from_macos "zip" => :test
  uses_from_macos "bzip2"
  uses_from_macos "unzip"

  def install
    virtualenv_install_with_resources
  end

  # Test a simple unzip. Sample taken from unzip formula
  test do
    (testpath/"test1").write "Hello!"
    (testpath/"test2").write "Bonjour!"
    (testpath/"test3").write "Hej!"

    system "zip", "test.zip", "test1", "test2", "test3"
    %w[test1 test2 test3].each do |f|
      rm f
      refute_path_exists testpath/f, "Text files should have been removed!"
    end

    system bin/"dtrx", "--flat", "test.zip"

    %w[test1 test2 test3].each do |f|
      assert_path_exists testpath/f, "Failure unzipping test.zip!"
    end

    assert_equal "Hello!", (testpath/"test1").read
    assert_equal "Bonjour!", (testpath/"test2").read
    assert_equal "Hej!", (testpath/"test3").read
  end
end
