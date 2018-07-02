class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/0.8.4.tar.gz"
  sha256 "e78da4306f01bf4070d7904066f5253058866a9888ca59fc3a08a2a547607b5c"

  bottle do
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
    system "cargo", "install", "--root", prefix, *args
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
