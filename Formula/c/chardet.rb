class Chardet < Formula
  include Language::Python::Virtualenv

  desc "Python character encoding detector"
  homepage "https://chardet.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/91/d7/47988d40231b41376f5a66346ef3b322c81091dfd4c0f84df5a1e3bb06b5/chardet-7.4.0.post1-py3-none-any.whl"
  sha256 "57a62ef50f69bc2fb3a3ea1ffffec6d10f3d2112d3b05d6e3cb15c2c9b55f6cc"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e39f8e870d745309f53ec9d8eae94a7879a31641a3de44e7adf7c4f5397c95e3"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.txt").write "你好"
    output = shell_output("#{bin}/chardetect #{testpath}/test.txt")
    assert_match "test.txt: utf-8 with confidence", output
  end
end
