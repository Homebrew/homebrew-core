class Austin < Formula
  desc "Python frame stack sampler for CPython"
  homepage "https://github.com/P403n1x87/austin"
  url "https://github.com/P403n1x87/austin/archive/v3.0.0.tar.gz"
  sha256 "df57cd33e74fe9b7b0c87ea82827b0d7863cc5761bd3e75b3367d7d3384c3836"
  license "GPL-3.0-or-later"
  head "https://github.com/P403n1x87/austin.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "64bd809bd02f8d4cc548faf3737ed110176a013d294c75f33deebaf37478bcd2"
    sha256 cellar: :any_skip_relocation, big_sur:       "ca848fe3df7f23f587130c513162f014a5c527de876b4daed5b771cfcdef4a63"
    sha256 cellar: :any_skip_relocation, catalina:      "fd66332fc1c28de38e489abe6589acd135a75f5d4f058350e6406960e90536e0"
    sha256 cellar: :any_skip_relocation, mojave:        "01fd01e344f256fcaa06733821873a7d29051c8d79df780bdee413840fa8469f"
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
