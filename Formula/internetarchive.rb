class Internetarchive < Formula
  include Language::Python::Virtualenv

  desc "Python wrapper for the various Internet Archive APIs"
  homepage "https://github.com/jjjake/internetarchive"
  url "https://files.pythonhosted.org/packages/14/29/5816453369ed24c43137408d15de0058ce19e12284ec926695102b80cb0b/internetarchive-1.9.6.tar.gz"
  sha256 "0e9b24577086283280a5089b3e65086640b4e42d61ca4af913639f45b02b9e4c"
  license "AGPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "969e7aa41adecbb73ef893eb4850b3737be34c2875dd75eea4cf3dad9403ca4d" => :big_sur
    sha256 "5a73fdffe6265ff22b2fba541825ef5359f4f9d99474c3079b9949c899f1dd3b" => :arm64_big_sur
    sha256 "18becdb072b9cc6b1d14cfcc22a73ac3bc7aefab713ac12f94bdedaaa9a03e5c" => :catalina
    sha256 "b6e3ff557945f3737afa34dba3a04149e5cb5a6114300835113a191435deb773" => :mojave
    sha256 "abcdcd519699bab6a16e5458f50be52cfb79a81095933c7f06e6bcc2172e47c2" => :high_sierra
  end

  depends_on "python@3.9"

  resource "backports.csv" do
    url "https://files.pythonhosted.org/packages/79/0c/d0eaa9380189a292121acab65199ac95b9209b45006ad8aa5266abd36943/backports.csv-1.0.7.tar.gz"
    sha256 "1277dfff73130b2e106bf3dd347adb3c5f6c4340882289d88f31240da92cbd6d"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/e6/de/879cf857ae6f890dfa23c3d6239814c5471936b618c8fb0c8732ad5da885/certifi-2020.11.8.tar.gz"
    sha256 "f05def092c44fbf25834a51509ef6e631dc19765ab8a57b4e7ab85531f0a9cf4"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "contextlib2" do
    url "https://files.pythonhosted.org/packages/02/54/669207eb72e3d8ae8b38aa1f0703ee87a0e9f88f30d3c0a47bebdb6de242/contextlib2-0.6.0.post1.tar.gz"
    sha256 "01f490098c18b19d2bd5bb5dc445b2054d2fa97f09a4280ba2c5f3c394c8162e"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/69/72/24826f61fe4ba535207ed8efe17c82a5e9f9fdf2247054ae829b5c134b71/jsonpatch-1.26.tar.gz"
    sha256 "e45df18b0ab7df1925f20671bbc3f6bd0b4b556fb4b9c5d97684b0a7eac01744"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/52/e7/246d9ef2366d430f0ce7bdc494ea2df8b49d7a2a41ba51f5655f68cfe85f/jsonpointer-2.0.tar.gz"
    sha256 "c192ba86648e05fdae4f08a17ec25180a9aef5008d973407b581798a83975362"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/da/67/672b422d9daf07365259958912ba533a0ecab839d4084c487a5fe9a5405f/requests-2.24.0.tar.gz"
    sha256 "b3559a131db72c33ee969480840fff4bb6dd111de7dd27c8ee1f820f4f00231b"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/c2/13/7332387fabc217b04ce7c4a3286fd1049444991b44cd8f143354e7f8f1fd/schema-0.7.3.tar.gz"
    sha256 "4cf529318cfd1e844ecbe02f41f7e5aa027463e7403666a52746f31f04f47a5e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/88/e6/13dde83089386c9aa200c4539891948094443d4f6fe85fe95c7806c1f3d5/tqdm-4.51.0.tar.gz"
    sha256 "ef54779f1c09f346b2b5a8e5c61f96fbcb639929e640e59f8cf810794f406432"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/76/d9/bbbafc76b18da706451fa91bc2ebe21c0daf8868ef3c30b869ac7cb7f01d/urllib3-1.25.11.tar.gz"
    sha256 "8d7eaa5a82a1cac232164990f04874c594c9453ec55eef02eab885aa02fc17a2"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/ia"
  end

  test do
    metadata = JSON.parse shell_output("#{bin}/ia metadata tigerbrew")
    assert_equal metadata["metadata"]["uploader"], "mistydemeo@gmail.com"
  end
end
