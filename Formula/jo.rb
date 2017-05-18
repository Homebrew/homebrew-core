class Jo < Formula
  desc "JSON output from a shell"
  homepage "https://github.com/jpmens/jo"
  url "https://github.com/jpmens/jo/releases/download/v1.1/jo-1.1.tar.gz"
  sha256 "63ed4766c2e0fcb5391a14033930329369f437d7060a11d82874e57e278bda5f"

  bottle do
    cellar :any_skip_relocation
    sha256 "776d6f4bcaed2fd57b0fa313331a905c7e47a31ec13629559c9e48853f22777e" => :sierra
    sha256 "c94c62f3918266cbd688da0b54274226f0fc5d31b311b6be47f523d184f3e503" => :el_capitan
    sha256 "c46c74107062d4b419255e5a3bc44caea10cbc2ee290e7fdfbaa1dd254b18e4b" => :yosemite
    sha256 "25e096147b71cdfe6f6230b6340c577335517fabbbf05027f41db4878629f726" => :mavericks
  end

  head do
    url "https://github.com/jpmens/jo.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "autoreconf", "-i" if build.head?

    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal %Q({"success":true,"result":"pass"}\n), pipe_output("#{bin}/jo success=true result=pass")
  end
end
