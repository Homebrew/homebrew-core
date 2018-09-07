class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/0.8.5.tar.gz"
  sha256 "0c4f946e873e26777423e1bab37392220aec9382ae818866d2e3a52b3c976cf1"

  bottle do
    sha256 "cb7b99424c08b3e7a378af0be915e93938742fa80f94c1cc6dfa395e1873a83d" => :mojave
    sha256 "c3f9147ebd6b71ad2ee29f642b9eb9ab7ec6ca57d07b2f93f716833e045f26a2" => :high_sierra
    sha256 "dc70290671ad0e3f7b89be4d9a205280cb5361d89e3432794dfab0e2df2d0b30" => :sierra
    sha256 "723cddd4ed7608e4c1f56915c7a7a26362a94525d70432ba0d803552a9645b7a" => :el_capitan
  end

  option "with-openmp", "Enable OpenMP multithreading"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "gcc" if build.with? "openmp"

  fails_with :clang if build.with? "openmp"

  def install
    args = []
    args << "--features=openmp" if build.with? "openmp"
    system "cargo", "install", "--root", prefix, "--path", ".", *args
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
