class Livestreamer < Formula
  include Language::Python::Virtualenv

  desc "Pipes video from streaming services into a player such as VLC"
  homepage "https://livestreamer.io/"
  url "https://files.pythonhosted.org/packages/ee/d6/efbe3456160a2c62e3dd841c5d9504d071c94449a819148bb038b50d862a/livestreamer-1.12.2.tar.gz"
  sha256 "ef3e743d0cabc27d8ad906c356e74370799e25ba46c94d3b8d585af77a258de0"
  license "BSD-2-Clause"
  revision 5

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e2e04a90df81ab82d3fe1d44640c2b4400ddec952797f44e1c005c0ab8d8c4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e2e04a90df81ab82d3fe1d44640c2b4400ddec952797f44e1c005c0ab8d8c4d"
    sha256 cellar: :any_skip_relocation, monterey:       "f479bd547db6c63cb62ad292c9ef75d18299fd7102d72d82a5b61352d3d720fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "f479bd547db6c63cb62ad292c9ef75d18299fd7102d72d82a5b61352d3d720fa"
    sha256 cellar: :any_skip_relocation, catalina:       "f479bd547db6c63cb62ad292c9ef75d18299fd7102d72d82a5b61352d3d720fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acc79d143599e834180032898376d7ceb4cdb0077da250b8db0aaac55e7434e9"
  end

  depends_on "python@3.10"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/livestreamer --version 2>&1")
  end
end
