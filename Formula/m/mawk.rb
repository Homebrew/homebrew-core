class Mawk < Formula
  desc "Interpreter for the AWK Programming Language"
  homepage "https://invisible-island.net/mawk/"
  url "https://invisible-mirror.net/archives/mawk/mawk-1.3.4-20240622.tgz"
  sha256 "4e917e87a7a9fbaf76995784a4b0b5dc0dd954b977d0983030f78f6a07b1a765"
  license "GPL-2.0-only"

  livecheck do
    url "https://invisible-mirror.net/archives/mawk/?C=M&O=D"
    regex(/href=.*?mawk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de5f17b5bd00e5a112d28eb18baafce3a8c3768397706715593c0e17610a76f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e67aa0474c1aef9559d2b1a37c0faca1c3110e2310a8b7d049a38ca682e02ceb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2397a78e62b3394bb739807c1ce40222b075f473ce2459b64e8912d9496a46f"
    sha256 cellar: :any_skip_relocation, sonoma:         "57c693bd578b8bc78defa24925dfb33220efa35b53773c069f00c7796f2620aa"
    sha256 cellar: :any_skip_relocation, ventura:        "9a87329bcd690ad975d6eaf2b0f45993c6f6197cd6842d39b2ddbdecf8e6db15"
    sha256 cellar: :any_skip_relocation, monterey:       "c3991277902329c8a20812194806707b3c80799a5bdab25deafa22542586c7e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3f8a4c9fdf346617c5a43124e12a615429e90b00203376395f8b7cf3561fe81"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-silent-rules",
                          "--with-readline=/usr/lib",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    mawk_expr = '/^mawk / {printf("%s-%s", $2, $3)}'
    ver_out = pipe_output("#{bin}/mawk '#{mawk_expr}'", shell_output("#{bin}/mawk -W version 2>&1"))
    assert_equal version.to_s, ver_out
  end
end
