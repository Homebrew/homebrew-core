class Dtrx < Formula
  include Language::Python::Virtualenv

  desc "Intelligent archive extraction"
  homepage "https://pypi.org/project/dtrx/"
  url "https://files.pythonhosted.org/packages/b7/e6/204294b57be7bb5072c217a1c3ddd5acf9b60b006c215e13e11121c04108/dtrx-8.5.3.tar.gz"
  sha256 "eec67869b85068fac8406f5018d781aee5b55422f3b7698bfea43468b2cec67c"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a1c04af670ced811950bb65e3ad904f2fe306b495e9ce1ebc1f0c816d016c088"
  end

  # Include a few common decompression handlers in addition to the python dep
  depends_on "p7zip"
  depends_on "python@3.13"
  depends_on "xz"

  uses_from_macos "zip" => :test
  uses_from_macos "bzip2"
  uses_from_macos "unzip"

  # Apply commit from open PR to fix `--flat` on Python 3.12+
  # Issue ref: https://github.com/dtrx-py/dtrx/issues/58
  # PR ref: https://github.com/dtrx-py/dtrx/pull/59
  patch do
    url "https://github.com/dtrx-py/dtrx/commit/4f2868c87e7d2eef97c9dbcbea4d1738e947463d.patch?full_index=1"
    sha256 "f81b0ed271ddfa22ee0e1d26f9ac3c5ea3e979497918594e8fc266b24b561a51"
  end

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
