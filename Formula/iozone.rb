class Iozone < Formula
  desc "File system benchmark tool"
  homepage "http://www.iozone.org/"
  url "http://www.iozone.org/src/current/iozone3_471.tar"
  sha256 "2dd29703c251044513069e0fdad0205e117ba846a0b54b45a93a684eda58c370"

  bottle do
    cellar :any_skip_relocation
    sha256 "0fdabe9bac1f9c8c14a0f5c6cf4a9477b5b2f4f0a4119e2fd5d49c278261120b" => :high_sierra
    sha256 "424dc5b525a599763f2c0d1d5e7ac88e040fcabb4c410e20a7709382f52255e5" => :sierra
    sha256 "1d692fc382bce67c04f2c3581e5388df4e7a77d6d735d1f4efee9226b470b235" => :el_capitan
  end

  # Remove for > 3.471
  # Upstream fix for "fileop.c:127:6: error: expected parameter declarator"
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/7e8a57a/iozone/bzero.patch"
    sha256 "0121dc8a43c99727d754c9c418ca79136cbf47f5713825d176f8e9f061401f2b"
  end

  def install
    cd "src/current" do
      system "make", "macosx", "CC=#{ENV.cc}"
      bin.install "iozone"
      pkgshare.install %w[Generate_Graphs client_list gengnuplot.sh gnu3d.dem
                          gnuplot.dem gnuplotps.dem iozone_visualizer.pl
                          report.pl]
    end
    man1.install "docs/iozone.1"
  end

  test do
    assert_match "File size set to 16384 kB",
      shell_output("#{bin}/iozone -I -s 16M")
  end
end
