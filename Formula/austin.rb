class Austin < Formula
  desc "Python frame stack sampler for CPython"
  homepage "https://github.com/P403n1x87/austin"
  url "https://github.com/P403n1x87/austin/archive/v1.0.1.tar.gz"
  sha256 "f86804f777f2f466ddede5d530d3ca67582b2a1467d000662d81272d6e9c5639"

  head "https://github.com/P403n1x87/austin.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.8" => :test

  def install
    system "autoreconf", "--install"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    man1.install "debian/austin.1"
  end

  test do
    shell_output("#{bin}/austin #{Formula["python@3.8"].opt_bin}/python3 -c \"print('Test')\"", 33)
  end
end
