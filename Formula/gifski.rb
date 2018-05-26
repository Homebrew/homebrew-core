class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/0.8.3.tar.gz"
  sha256 "f954f0ff2c356ca94c89b38f1dbc7951b2187b237cff513916445614aeb8d7f9"

  bottle do
    sha256 "4374b014b9c845aaf2943d9dbde7918894dec9badb0bb8b3538b5ab9eed4850a" => :high_sierra
    sha256 "98e56b162d264b55426510abf621400b5e3376883d4492f6ef1254c94765751c" => :sierra
    sha256 "5c5eab4a689ff923926f5f5088c03ff1a4d5a9d5e50f9339846a0d8f2ebeb5c5" => :el_capitan
  end

  option "with-openmp", "Enable OpenMP multithreading"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "gcc" if build.with? "openmp"

  fails_with :clang if build.with? "openmp"

  def install
    args = ["--release"]
    args << "--features=openmp" if build.with? "openmp"
    system "cargo", "build", *args
    bin.install "target/release/gifski"
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
