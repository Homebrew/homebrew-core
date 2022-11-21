class Flit < Formula
  include Language::Python::Virtualenv

  desc "Simplified packaging of Python modules"
  homepage "https://github.com/pypa/flit"
  url "https://files.pythonhosted.org/packages/28/c6/c399f38dab6d3a2518a50d334d038083483a787f663743d713f1d245bde3/flit-3.8.0.tar.gz"
  sha256 "d0f2a8f4bd45dc794befbf5839ecc0fd3830d65a57bd52b5997542fac5d5e937"
  license "BSD-3-Clause"
  head "https://github.com/pypa/flit.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bd28c6b210602e16d0430cfde9bea90bc36c3f3c8df5462e8894a2a6231e615"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dbf8a9e8e9df5301a978774c79361bccb722227344b8257de66aef1f89864b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d424220d30faa14fcd391ae4acbcdcdb3b923ca4237990d85b5a15f614f5090b"
    sha256 cellar: :any_skip_relocation, ventura:        "d8c0d3c83ec706d3c8db72b4ce50fa58fd05e230e6f4bc61836c7c024fe03ad2"
    sha256 cellar: :any_skip_relocation, monterey:       "ec577206379daaaab4f712994a1a546a8a79b2b335165f374058cff750191ca9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a28df2da3dc584cc9ff6e2159e2bc0c33caadd813611d9a4aaad7b1d257762b4"
    sha256 cellar: :any_skip_relocation, catalina:       "3da182a01a57251992616c5275d64781206644df7d7d9d8d5b31636b0b7e8fdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db0339e8e776366d78171427ccbd679f4566ad1715935aa1e9dc320615d37b6a"
  end

  depends_on "docutils"
  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/10/e5/be08751d07b30889af130cec20955c987a74380a10058e6e8856e4010afc/flit_core-3.8.0.tar.gz"
    sha256 "b305b30c99526df5e63d6022dd2310a0a941a187bd3884f4c8ef0418df6c39f3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/49/05/6bf21838623186b91aedbda06248ad18f03487dc56fbc20e4db384abde6c/tomli_w-1.0.0.tar.gz"
    sha256 "f463434305e0336248cac9c2dc8076b707d8a12d019dd349f5c1e382dd1ae1b9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"sample.py").write <<~END
      """A sample package"""
      __version__ = "0.1"
    END
    (testpath/"pyproject.toml").write <<~END
      [build-system]
      requires = ["flit_core"]
      build-backend = "flit_core.buildapi"

      [tool.flit.metadata]
      module = "sample"
      author = "Sample Author"
    END
    system bin/"flit", "build"
    assert_predicate testpath/"dist/sample-0.1-py2.py3-none-any.whl", :exist?
    assert_predicate testpath/"dist/sample-0.1.tar.gz", :exist?
  end
end
