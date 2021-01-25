class Austin < Formula
  desc "Python frame stack sampler for CPython"
  homepage "https://github.com/P403n1x87/austin"
  url "https://github.com/P403n1x87/austin/archive/v2.1.1.tar.gz"
  sha256 "adc7ce66478142ae0e0922c8ad2031dbf908c6d9fa2c3f6e9793888bd11e67ab"
  license "GPL-3.0-or-later"
  head "https://github.com/P403n1x87/austin.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca848fe3df7f23f587130c513162f014a5c527de876b4daed5b771cfcdef4a63" => :big_sur
    sha256 "64bd809bd02f8d4cc548faf3737ed110176a013d294c75f33deebaf37478bcd2" => :arm64_big_sur
    sha256 "fd66332fc1c28de38e489abe6589acd135a75f5d4f058350e6406960e90536e0" => :catalina
    sha256 "01fd01e344f256fcaa06733821873a7d29051c8d79df780bdee413840fa8469f" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.9" => :test

  def install
    system "autoreconf", "--install"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    man1.install "src/austin.1"
  end

  test do
    shell_output("#{bin}/austin #{Formula["python@3.9"].opt_bin}/python3 -c \"from time import sleep; sleep(1)\"", 37)
  end
end
