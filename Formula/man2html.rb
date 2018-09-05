class Man2html < Formula
  desc "Convert nroff man pages to HTML"
  homepage "https://savannah.nongnu.org/projects/man2html/"
  url "https://www.mhonarc.org/release/misc/man2html3.0.1.tar.gz"
  mirror "https://distfiles.macports.org/man2html/man2html3.0.1.tar.gz"
  sha256 "a3dd7fdd80785c14c2f5fa54a59bf93ca5f86f026612f68770a0507a3d4e5a29"

  bottle do
    cellar :any_skip_relocation
    sha256 "5096761bebb1f08c8eb8bac3e99b35884116086b7e39bf3d3daad3340645ff75" => :mojave
    sha256 "9fe2dcdd8c5f344106dfe57db3e70bec51f78594fb2c968f5561506d1bd7dbbe" => :high_sierra
    sha256 "ced5194219735226831e611db4247de1affdec0c2e53e813d5c1a7c5d3bce928" => :sierra
    sha256 "37bfcf3cab42938fff23a66429872e935b59cf769caf238928bd4acc6544d8d4" => :el_capitan
    sha256 "2e3cc12c0e7bc0ae5b194f397874015df1fe6b8a8ab52c6972e17ad992732463" => :yosemite
    sha256 "7ebaf5a969df65809220222b69414a51ed06b90601a28fc2ad140955e17febe0" => :mavericks
    sha256 "82efff57b082ea9f817287e96d185bf15f351cfb0d4a7c3837f89bb5e14ce30c" => :mountain_lion
  end

  def install
    bin.mkpath
    man1.mkpath
    system "/usr/bin/perl", "install.me", "-batch",
                            "-binpath", bin,
                            "-manpath", man
  end

  test do
    pipe_output("#{bin}/man2html", (man1/"man2html.1").read, 0)
  end
end
