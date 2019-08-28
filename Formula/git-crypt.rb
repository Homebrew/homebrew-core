class GitCrypt < Formula
  desc "Enable transparent encryption/decryption of files in a git repo"
  homepage "https://www.agwa.name/projects/git-crypt/"
  url "https://www.agwa.name/projects/git-crypt/downloads/git-crypt-0.6.0.tar.gz"
  sha256 "6d30fcd99442d50f4b3c8d554067ff1d980cdf9f3120ee774131172dba98fd6f"
  revision 1

  bottle do
    cellar :any
    sha256 "97efb22a9788ddec6ca90a6587be40681ffeac38702defe635ea40110b049b1b" => :mojave
    sha256 "03bde5159a767e33afba44e6d14f937e0a1864a50035280ac59784da0738e712" => :high_sierra
    sha256 "b89552d865cfd7f2473f681a669ae63a0ee980c5cdee6d97a3d8189a3eac6ddd" => :sierra
    sha256 "e456ffd793629abea8debdcb761ff73ff2dcfe60493a298f763d238822add437" => :el_capitan
  end

  depends_on "openssl@1.1"

  def install
    system "make"
    bin.install "git-crypt"
  end

  test do
    system "#{bin}/git-crypt", "keygen", "keyfile"
  end
end
