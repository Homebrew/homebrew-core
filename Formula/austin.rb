class Austin < Formula
  desc "Python frame stack sampler for CPython"
  homepage "https://github.com/P403n1x87/austin"
  url "https://github.com/P403n1x87/austin/archive/v1.0.1.tar.gz"
  sha256 "f86804f777f2f466ddede5d530d3ca67582b2a1467d000662d81272d6e9c5639"
  license "GPL-3.0"
  head "https://github.com/P403n1x87/austin.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d54d25854d57ba21937ee4cf57bf9948f084e38afb19723150c787e2742697c2" => :catalina
    sha256 "7e87587953588d5f50dbdaa09d731653f1fa354913da4bcc43a34b505cfde2fa" => :mojave
    sha256 "700f3399a63c70da0b0ee0a3be9d64a886ea503a7ea9192062998a63d8a7f23b" => :high_sierra
  end

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
