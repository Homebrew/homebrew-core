class B4 < Formula
  include Language::Python::Virtualenv

  desc "Tool to work with public-inbox and patch archives"
  homepage "https://b4.docs.kernel.org/en/latest/"
  url "https://files.pythonhosted.org/packages/3b/89/70da0dcb6a75833a388aeb15aef12d859950793f8ce68faff757df97d1e3/b4-0.16.0.tar.gz"
  sha256 "071823a1e904508a6fd9aaf8cc2f9a92697e1dfa270000b4d1130015b56f4137"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9c99ebc9e8c3cc07cc9ab7c57115b1c4c572adaad772408fd54d2d8c511b1a6d"
    sha256 cellar: :any, arm64_sequoia: "afd8552c95c1f88103d20f549627aac0d6051f0cf7deaf535ec005987695ad2d"
    sha256 cellar: :any, arm64_sonoma:  "10b3ce2c3dda1f14b868d3dac290a20a042e036df6f08a995ebd24cdd38ab848"
    sha256 cellar: :any, sonoma:        "eb3fda162a22598be3154f03e46c892bf12e35b3bcc3860481f547763f244e7b"
    sha256 cellar: :any, arm64_linux:   "a01c335753eb1c64f0f0a1383964bd580e11862691169f817050d94e6a70f738"
    sha256 cellar: :any, x86_64_linux:  "c32838bb2e3745c92fddb0afa6051d003ed16e9ba0cf20040fca5a9837853cdc"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cffi" => :no_linkage
  depends_on "libgit2"
  depends_on "libsodium"
  depends_on "python@3.14"

  pypi_packages exclude_packages: ["certifi", "cffi"]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
  end

  resource "dkimpy" do
    url "https://files.pythonhosted.org/packages/f0/6f/84e91828186bbfcedd7f9385ef5e0d369632444195c20e08951b7ffe0481/dkimpy-1.1.8.tar.gz"
    sha256 "b5f60fb47bbf5d8d762f134bcea0c388eba6b498342a682a21f1686545094b77"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "ezgb" do
    url "https://files.pythonhosted.org/packages/bd/35/b765be847cd02e6282d8374d7082f97eec8afa6ad40efdf8e22e27ff9004/ezgb-0.2.0.tar.gz"
    sha256 "f758d883ad63efead5afe5a1b311d6adc9ddc22eb67c901d474cced32d66e2f5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "liblore" do
    url "https://files.pythonhosted.org/packages/fa/1c/977577255b58e57e0c11667e069f943a0cac1b8d74c65bc501e0649032bf/liblore-0.8.1.tar.gz"
    sha256 "0499dc2f29973d3612d8c49855d891d24f69ef1c8899ad514e730f59cd33c513"
  end

  resource "patatt" do
    url "https://files.pythonhosted.org/packages/60/84/ce3398941bcb26a5ee12a066a5d2b052bf9211f713d98ed78573b5364fea/patatt-0.8.0.tar.gz"
    sha256 "c226b5e7e449a4981b827c48e2586a928fa45b690af19a3892b9279b334f2551"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/a6/44/415aa93422b4bfc21a6448acb7e16280d5f33a9a3fae38a384e37b046ae4/pygit2-1.19.3.tar.gz"
    sha256 "a543e6d4ebb43825564935758dc234e770016fed673b84370d46ae9580558831"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/b4 --version")

    ENV["GIT_CONFIG_GLOBAL"] = "#{testpath}/.gitconfig"
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Homebrew
        email = foo@brew.sh
    EOS
    assert_match "No thanks necessary.", shell_output("#{bin}/b4 ty 2>&1")
  end
end
