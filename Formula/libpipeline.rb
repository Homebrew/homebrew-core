class Libpipeline < Formula
  desc "Library for manipulating pipelines of subprocesses"
  homepage "http://libpipeline.nongnu.org/"
  url "https://download.savannah.gnu.org/releases/libpipeline/libpipeline-1.3.1.tar.gz"
  sha256 "5cad1b446f135ec3800d32c8c951a1114f4c438609a4c52b262c30301bc8e692"
  # tag "linuxbrew"

  head do
    url "git://git.savannah.nongnu.org/libpipeline.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a264032c0c4a781b63aa033cb1d5f0f69d667b8b7eb575298c9003a20a627846" => :x86_64_linux
  end

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end
end
