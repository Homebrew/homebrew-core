class Jo < Formula
  desc "JSON output from a shell"
  homepage "https://github.com/jpmens/jo"
  url "https://github.com/jpmens/jo/releases/download/1.2/jo-1.2.tar.gz"
  sha256 "36ec2fc4937c6478467684b18f0b213ff7267d34f5626cd5a0996a39ca64adae"

  bottle do
    cellar :any_skip_relocation
    sha256 "46d94e6735d051174c5d0a1931a821aeb7e52e8e429b10fce310eaad69596dcf" => :catalina
    sha256 "5dc83773f2bf1dc245498a5b3869f94539197292fdbfc49d34b5f2ebb8630685" => :mojave
    sha256 "0fe9b043869cbd4149ce411b585b9fc5814f3c4b76bcb875c93b4dd08126d7bc" => :high_sierra
    sha256 "e5ddb95312a7d34c0e4533c1dc21a6f854a8e8505b17116617e1b79538b6b0a0" => :sierra
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
