class Abjad < Formula
  include Language::Python::Virtualenv

  desc "Python API for building LilyPond files"
  homepage "https://abjad.github.io"
  url "https://files.pythonhosted.org/packages/67/7f/9bfa1bb008820b96105f70e8e9dc0d68e019d14998456711a18f2e3a32df/abjad-3.4.tar.gz"
  sha256 "c97a21cb420c2332d86b38dc0825b1df34e358033ea0c7384cadd73726a9167a"
  license "GPL-3.0-only"

  depends_on "lilypond"
  depends_on "python@3.9"
  depends_on "six"

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/17/e6/ec9aa6ac3d00c383a5731cc97ed7c619d3996232c977bb8326bcbb6c687e/Babel-2.9.1.tar.gz"
    sha256 "bc0c176f9f6a994582230df350aa6e05ba2ebe4b3ac317eab29d9be5d2768da0"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/4c/17/559b4d020f4b46e0287a2eddf2d8ebf76318fd3bd495f1625414b052fdc9/docutils-0.17.1.tar.gz"
    sha256 "686577d2e4c32380bb50cbb22f575ed742d58168cee37e99117a854bcd88f125"
  end

  resource "imagesize" do
    url "https://files.pythonhosted.org/packages/e4/9f/0452b459c8ba97e07c3cd2bd243783936a992006cf4cd1353c314a927028/imagesize-1.2.0.tar.gz"
    sha256 "b1f6b5a4eab1f73479a50fb79fcf729514a900c341d8503d62a62dbc4127a2b1"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/f8/86/7c0eb6e8b05385d1ce682abc0f994abd1668e148fb52603fa86e15d4c110/Jinja2-3.0.2.tar.gz"
    sha256 "827a0e32839ab1600d4eb1c4c33ec5a8edfbc5cb42dafa13b81f182f97784b45"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/e3/8e/1cde9d002f48a940b9d9d38820aaf444b229450c0854bdf15305ce4a3d1a/pytz-2021.3.tar.gz"
    sha256 "acad2d8b20a1af07d4e4c9d2e9285c5ed9104354062f275f3fcd88dcef4f1326"
  end

  resource "quicktions" do
    url "https://files.pythonhosted.org/packages/10/fa/5008e5a2eb8c891db681e4f0d50dff9895c32b4ed022b3ceb10160c788f2/quicktions-1.11.tar.gz"
    sha256 "f66f0f6e8cc4eb3702fc7b4fb943db17c72f875bcb5c91f50af188d28d0aa2df"
  end

  resource "roman" do
    url "https://files.pythonhosted.org/packages/49/bc/98ff27d555e8315fc572fb84cb72219322a4ea562ab776687c6fd45335c1/roman-3.3.tar.gz"
    sha256 "2c46ac8db827d34e4fa9ccc0577e7f0b0d84f16ffe112351bd4f1ec2eb12d73f"
  end

  resource "Sphinx" do
    url "https://files.pythonhosted.org/packages/c4/55/38d9661f2eca2a0d4cf891de61d8f9bdc9e8711b473012f36d90009677c5/Sphinx-4.2.0.tar.gz"
    sha256 "94078db9184491e15bce0a56d9186e0aec95f16ac20b12d00e06d4e36f1058a6"
  end

  resource "Unidecode" do
    url "https://files.pythonhosted.org/packages/41/a6/93288318cfae2fa0ca978dfe6bb94b22b7e9a9e98b6149a4af00b1e76ee8/Unidecode-1.3.2.tar.gz"
    sha256 "669898c1528912bcf07f9819dc60df18d057f7528271e31f8ec28cc88ef27504"
  end

  resource "uqbar" do
    url "https://files.pythonhosted.org/packages/77/ff/798c38a10c060d11eae8b53b46a995419219463b8f0f4aa2ad7d3972e93c/uqbar-0.4.8.tar.gz"
    sha256 "25bfab43b5d67e50762b21da49fc7d8439406b7ca31b063f3e34299949f1a5e6"
  end

  def install
    virtualenv_install_with_resources

    python_version = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    (lib/"python#{python_version}/site-packages/homebrew-abjad.pth").write <<~EOS
      import site; site.addsitedir('#{libexec}/lib/python#{python_version}/site-packages')
    EOS
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import abjad"
  end
end
