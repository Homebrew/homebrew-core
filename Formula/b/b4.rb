class B4 < Formula
  include Language::Python::Virtualenv

  desc "Tool to work with public-inbox and patch archives"
  homepage "https://b4.docs.kernel.org/en/latest/"
  url "https://files.pythonhosted.org/packages/70/99/2b34c8451ad6599090f7d9045adb9f19270c2ed8cef4d52c179b297f8e37/b4-0.14.3.tar.gz"
  sha256 "31a4927b8dfbb5c97edfc9569cda3b6737bbfd8430881e8cc48a0b088ced6147"
  license "GPL-2.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "226178f28760b3e75b93ad075d7cba47415807704747091f0f9936bae9cebb77"
    sha256 cellar: :any,                 arm64_sequoia: "3a1458c9fecd965d519219cc0bf2b2118f0197ace563f85b6e111ca353da081d"
    sha256 cellar: :any,                 arm64_sonoma:  "bbc146f6f134b8bf3b4b35f10bd3bcd90a71e7bb6440ec62ca20379a38b563c2"
    sha256 cellar: :any,                 sonoma:        "7cabca1836d799761cb89839cb54f9f610c99f3477647c62b9ed065a3bf8238f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cfccc9296b18d132f87b4fd52cdb677fcc629396cbd817195d1b81d88f580ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d856f2ab7a98f6eb09662cae0a4a52fc638a5250bea634dda33d0e8f7e809854"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cffi" => :no_linkage
  depends_on "libsodium"
  depends_on "python@3.14"

  pypi_packages exclude_packages: ["certifi", "cffi"]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "dkimpy" do
    url "https://files.pythonhosted.org/packages/f0/6f/84e91828186bbfcedd7f9385ef5e0d369632444195c20e08951b7ffe0481/dkimpy-1.1.8.tar.gz"
    sha256 "b5f60fb47bbf5d8d762f134bcea0c388eba6b498342a682a21f1686545094b77"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "git-filter-repo" do
    url "https://files.pythonhosted.org/packages/b9/bb/7a283f568af6b0528ade65e8ace84bd6ba46003e429101bcd62c232d01a5/git_filter_repo-2.47.0.tar.gz"
    sha256 "411b27e68a080c07a69c233cb526dbc2d848b09a72f10477f4444dd0822cf290"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "patatt" do
    url "https://files.pythonhosted.org/packages/17/f9/d9c3ace058873379cec76fbe2ed887e8d47e55d56704018c29b35e30e440/patatt-0.7.0.tar.gz"
    sha256 "f7b2be8a15f251fbbc90c6b734ab910654a7a9d184369ce9e77b6d26e43b9eea"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/b4 --version")

    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Homebrew
        email = foo@brew.sh
    EOS
    assert_match "No thanks necessary.", shell_output("#{bin}/b4 ty 2>&1")
  end
end
