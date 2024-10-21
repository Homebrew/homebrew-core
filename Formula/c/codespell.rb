class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/a0/a9/98353dfc7afcdf18cffd2dd3e959a25eaaf2728cf450caa59af89648a8e4/codespell-2.3.0.tar.gz"
  sha256 "360c7d10f75e65f67bad720af7007e1060a5d395670ec11a7ed1fed9dd17471f"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4264540b239225b10a614c5ea2a34102983e9d69553e0e884eb2657962f9ae9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4264540b239225b10a614c5ea2a34102983e9d69553e0e884eb2657962f9ae9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4264540b239225b10a614c5ea2a34102983e9d69553e0e884eb2657962f9ae9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0e8d1408cade997885fd7cc609e4322964e9ce128a34091caf950dad2e808c6"
    sha256 cellar: :any_skip_relocation, ventura:       "a0e8d1408cade997885fd7cc609e4322964e9ce128a34091caf950dad2e808c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4264540b239225b10a614c5ea2a34102983e9d69553e0e884eb2657962f9ae9b"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", pipe_output("#{bin}/codespell -", "teh", 65)
  end
end
