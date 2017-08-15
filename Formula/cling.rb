# Documentation: https://docs.brew.sh/Formula-Cookbook.html
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Cling < Formula
  desc "The interactive C++ interpreter Cling"
  homepage "https://rawgit.com/vgvassilev/cling/master/www/index.html"
  url "https://github.com/vgvassilev/cling/archive/v0.4.tar.gz"
  sha256 "67b181309c5fe712dcd00903d48fb6965c46d517847d0b7f506a1921ba2f56b6"

  depends_on "cmake" => :build
  depends_on "llvm" => :build

  resource "cling" do
    url "https://github.com/vgvassilev/cling/archive/v0.4.tar.gz"
    sha256 "67b181309c5fe712dcd00903d48fb6965c46d517847d0b7f506a1921ba2f56b6"
  end

  resource "clang" do
    url "https://github.com/vgvassilev/clang.git", :using => :git, :tag => "cling-patches-r302975", :revision => "1d3611b352ada6e8fc8dd41631bd17495f37b258"
    sha256 "1d3611b352ada6e8fc8dd41631bd17495f37b258"
  end

  def install
    (buildpath/"tools/clang").install resource("clang")
    (buildpath/"tools/cling").install resource("cling")

    mktemp do
      system "cmake", "-G", "Unix Makefiles", buildpath, *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/cling", "-v"
  end
end
