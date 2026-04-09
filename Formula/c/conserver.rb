class Conserver < Formula
  desc "Allows multiple users to watch a serial console at the same time"
  homepage "https://www.conserver.com/"
  url "https://github.com/bstansell/conserver/releases/download/v8.3.0/conserver-8.3.0.tar.gz"
  sha256 "202b2ace3e14f36bca4de6ccd43cc962a99853c1d50799672ce0ffc5c02f8404"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "18a385e584cd2d5496a7a638a2eeb78a071b5ca4fc84dd4acadfc3b1d32d773c"
    sha256 cellar: :any,                 arm64_sequoia: "f316ec7ce2a3c077720937ae72f97c0ba14de6fa07c780153f38026275e55727"
    sha256 cellar: :any,                 arm64_sonoma:  "d46c8edcd5f6f406c7f22544e4660936e782f20b7c23f93337b7ae71b606e2c1"
    sha256 cellar: :any,                 sonoma:        "383529209992368495464900474448a0e19bc1afea889426ac8c43479b95aee9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5427990f7696fc5dbcb6f2d47256571c544384384011727da0b22e0771ed131e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e62d98d49a9f17bb8be6628da6758273db6c59f53ff11e9f601d7095ed35013"
  end

  depends_on "openssl@3"

  uses_from_macos "krb5"
  uses_from_macos "libxcrypt"

  conflicts_with "uffizzi", because: "both install `console` binaries"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-openssl", "--with-ipv6", "--with-gssapi", "--with-striprealm"
    system "make"
    system "make", "install"
  end

  test do
    console = spawn bin/"console", "-n", "-p", "8000", "test"
    sleep 1
    Process.kill("TERM", console)
    Process.wait(console)
  end
end
