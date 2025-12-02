class Fcgiwrap < Formula
  desc "CGI support for Nginx"
  homepage "https://www.nginx.com/resources/wiki/start/topics/examples/fcgiwrap/"
  url "https://github.com/gnosek/fcgiwrap/archive/refs/tags/1.1.0.tar.gz"
  sha256 "4c7de0db2634c38297d5fcef61ab4a3e21856dd7247d49c33d9b19542bd1c61f"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "6732ddaccbb813164f5b5a0f8b09901f15681e82de377939f5a173b046902bc7"
    sha256 cellar: :any,                 arm64_sequoia:  "c5bbbd4868035ccb9d9f03b894456f3d2e61a167a55f3d934f8c093d26a27e84"
    sha256 cellar: :any,                 arm64_sonoma:   "8978a76429865262b1d5acef3279849a91f46a49adfdee6555a9e0985d355c77"
    sha256 cellar: :any,                 arm64_ventura:  "0037b9cebb42c65b4381625dd9ae10a228ad246527ffe73ba718f4c2a7d5b551"
    sha256 cellar: :any,                 arm64_monterey: "8ddb35ceaf8709ed245ad937b559a8539c6fc1f2135b6ad40781cdf6ff86726f"
    sha256 cellar: :any,                 arm64_big_sur:  "b7f23b86cfdfcf813fadf2e7a3c228fa70476bae53c5617f20d810e07c7c355b"
    sha256 cellar: :any,                 sonoma:         "dd474ef1ba6c0fcfe6af59a9ef4f99314f7a7811c5553c8cefe9b25d75c81026"
    sha256 cellar: :any,                 ventura:        "578107ed37b7d8cc435a7b0d9f36ceca8f50500957145ebfd1d0dc6742dc4f16"
    sha256 cellar: :any,                 monterey:       "520ec05d4f3b387f30876075f77e0fce87c3fd12a616f9c8c08db683ca05510b"
    sha256 cellar: :any,                 big_sur:        "bd98b43c74955117affa9b619376f09eae18890dea9b4bdb3ea81b70c44024ac"
    sha256 cellar: :any,                 catalina:       "c8d117b2a7fed48905548381120a0ce80e6250ea434d8f62dde18fd12542ca04"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "71efd18bedccd162ba1df3ac939325de41e748e0dcad7a2fe2af6a0e8b6c4408"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59c76ede41a8876d1c9f2a737e79e314851b757a647d50cebea91247c185afc1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "fcgi"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end
end
