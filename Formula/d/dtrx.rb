class Dtrx < Formula
  include Language::Python::Virtualenv

  desc "Intelligent archive extraction"
  homepage "https://pypi.org/project/dtrx/"
  url "https://files.pythonhosted.org/packages/12/c2/e678320a0051cbbe5de91d1836998bac858086852a135441d7d0bfddc1c1/dtrx-8.7.1.tar.gz"
  sha256 "d3be625ce7860c82d5159a551bbd215eada8a11cf4f82557e4f77eabc0986e43"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6f928b08515be3e2f84897ce27a5d1448a127fcc3440171ee1fbaba7a40b0500"
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
