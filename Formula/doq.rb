class Doq < Formula
  include Language::Python::Virtualenv

  desc "Docstring generator for Python"
  homepage "https://github.com/heavenshell/py-doq"
  url "https://files.pythonhosted.org/packages/35/a0/c22615949f5270e8a0819d5a1278330468eeb6f8bfe495f574c5a869b57e/doq-0.7.0.tar.gz"
  sha256 "c323dc59857a1dbea3e7d71e73c6fb11a88a565c3a225b75e446f70f0659049b"
  license "BSD-3-Clause"

  depends_on "python@3.9"

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/0c/23cbcf515b5394e9f59a3e6629f26e1142b92d474ee0725a26aa5a3bcf76/Jinja2-3.0.0.tar.gz"
    sha256 "ea8d7dd814ce9df6de6a761ec7f1cac98afe305b8cdc4aaae4e114b8d8ce24c5"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/67/6a/5b3ed5c122e20c33d2562df06faf895a6b91b0a6b96a4626440ffe1d5c8e/MarkupSafe-2.0.0.tar.gz"
    sha256 "4fae0677f712ee090721d8b17f412f1cbceefbf0dc180fe91bab3232f38b4527"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/5e/61/d119e2683138a934550e47fc8ec023eb7f11b194883e9085dca3af5d4951/parso-0.8.2.tar.gz"
    sha256 "12b83492c6239ce32ff5eed6d3639d6a536170723c6f3f1506869f1ace413398"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"

    source_code = <<~EOS
      def compute(arg1, arg2: str) -> str:
          pass
    EOS
    (testpath/"compute.py").write(source_code)

    expected = <<~EOS
      def compute(arg1, arg2: str) -> str:
          """compute.

          :param arg1:
          :param arg2:
          :type arg2: str
          :rtype: str
          """
          pass
    EOS

    assert_equal expected, shell_output("#{bin}/doq -f #{testpath}/compute.py")
  end
end
