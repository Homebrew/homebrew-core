class Dtrx < Formula
  include Language::Python::Virtualenv

  desc "Intelligent archive extraction"
  homepage "https://pypi.org/project/dtrx/"
  url "https://files.pythonhosted.org/packages/3b/3b/426aacf32cfc661b1adbb61f3285367e9aff083252fd369a76bd3f565876/dtrx-8.5.0.tar.gz"
  sha256 "66e2e1d5bf98401aec70c44e78192ca478d2138c7a6395863e51d07b085355b0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79d57f98e77e7db091fca4366b4ba5b802dd6701f8f6cdd2319e33b97bce6e99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee4717644293fb60d28aa52cba2e97377942553a935fe244298630e8186673c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7b411cf09d028d15d21385f5ecf776ab2dcf0d0266d8645fba5e89bd0ae68a6"
    sha256 cellar: :any_skip_relocation, ventura:        "04ec6cffb870d361258a407cd9c3902b4958e648884a4e73b24b0f8f7b797e3d"
    sha256 cellar: :any_skip_relocation, monterey:       "2f5c95bff48c1abf26d3f9f50af103b6637bd83fd99c55e27e1a0c96e30011ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2a9e723f04f09663bc8f46c90932dd5d75a7c4f1ab9ed78b62f5cb6a9910656"
    sha256 cellar: :any_skip_relocation, catalina:       "3043ce0dcaacd4f746682a7c2c31b914e2942adebed523409087579c6e1b7707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5acc79a0c95cc06c9bd6154330218642fdba6bb676817f153eaf6fa45036de1"
  end

  # Include a few common decompression handlers in addition to the python dep
  depends_on "p7zip"
  depends_on "python@3.11"
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
      refute_predicate testpath/f, :exist?, "Text files should have been removed!"
    end

    system "#{bin}/dtrx", "--flat", "test.zip"

    %w[test1 test2 test3].each do |f|
      assert_predicate testpath/f, :exist?, "Failure unzipping test.zip!"
    end

    assert_equal "Hello!", (testpath/"test1").read
    assert_equal "Bonjour!", (testpath/"test2").read
    assert_equal "Hej!", (testpath/"test3").read
  end
end
