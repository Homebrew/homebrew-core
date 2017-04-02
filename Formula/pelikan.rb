class Pelikan < Formula
  desc "production-ready cache services"
  homepage "http://pelikan.io"
  url "https://github.com/twitter/pelikan/archive/0.1.2.tar.gz"
  sha256 "c105fdab8306f10c1dfa660b4e958ff6f381a5099eabcb15013ba42e4635f824"
  head "https://github.com/twitter/pelikan.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "37a675674b7ef33f07099029042f56c054f09b5d22400010d583fbfa41c0ce50" => :sierra
    sha256 "e314ce6288bf76e271bf69ce844e2e846b16cad68ce635faf1e5130c3c6911d0" => :el_capitan
    sha256 "ab04b8488e6272d0000c8e67842c4b286eb23459a6de9e9a392f14aa87c9978e" => :yosemite
    sha256 "80459134cbab7aa94ab55d38488b2058696f7408869306f75e80cfa0350ed40d" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    mkdir "_build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/pelikan_twemcache", "-c"
  end
end
