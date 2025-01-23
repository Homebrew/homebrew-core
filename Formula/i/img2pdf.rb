class Img2pdf < Formula
  include Language::Python::Virtualenv

  desc "Convert images to PDF via direct JPEG inclusion"
  homepage "https://gitlab.mister-muffin.de/josch/img2pdf"
  url "https://files.pythonhosted.org/packages/36/92/6ac4d61951ba507b499f674c90dfa7b48fa776b56f6f068507f8751c03f1/img2pdf-0.5.1.tar.gz"
  sha256 "73847e47242f4b5bd113c70049e03e03212936c2727cd2a8bf564229a67d0b95"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "f3573def2a29c6a218e73a9ede0e33222ae59faf67f52f07ea5f93565d21dcdd"
    sha256 cellar: :any,                 arm64_sonoma:  "b0cc3aae63f8605204f79569d7360efbcb809ff28a6695827becac78e3ab73bb"
    sha256 cellar: :any,                 arm64_ventura: "9be5bfeef8e77b9b41647b0689faaa179fde89ffbb933ef43cbb42359b43c7d8"
    sha256 cellar: :any,                 sonoma:        "af54a18cc25a6f45fbf3b3a6f66480947d4d5ca78ca811c3bb8e26d8117250a7"
    sha256 cellar: :any,                 ventura:       "20d68bf22e6b96a24e6eef9cdff3574f671d5b980fd1d0acca0f2a5e6a89f0a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08a21eb57faaafb20f42f19bdf1fc1fe733d9be1ca05963c3c42c5918e401b5c"
  end

  depends_on "pillow"
  depends_on "python@3.13"
  depends_on "qpdf"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/92/14/1e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232/Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e7/6b/20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269/lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/20/73/8d6bc14a66ba0ff107603e6aa0e9cb8fb356e217204f86d9328ab2393c92/pikepdf-9.3.0.tar.gz"
    sha256 "906d8afc1aa4f2f7409381a58e158207170f3aeba8ad2aec40072a648e8a2914"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"img2pdf", test_fixtures("test.png"), test_fixtures("test.jpg"),
                             test_fixtures("test.tiff"), "--pagesize", "A4", "-o", "test.pdf"
    assert_predicate testpath/"test.pdf", :exist?
  end
end
