class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/0.8.5.tar.gz"
  sha256 "0c4f946e873e26777423e1bab37392220aec9382ae818866d2e3a52b3c976cf1"

  bottle do
    sha256 "acf76ee232c73d8682814ef3eaebd143314d8406d972e5f93042ac579d263a12" => :mojave
    sha256 "ba26d7e59f381268f03c80539710060b6be978a214d1b0d7fda441c7e1aadd98" => :high_sierra
    sha256 "b4c232f074255a72f3886e2372f62d668d17b106392ed5c4a5fda1b57aa57275" => :sierra
    sha256 "b93399bf691af7d49c3f84930435c6bc516dc43aeebee1381615b9f032ffad78" => :el_capitan
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
