class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/0.8.3.tar.gz"
  sha256 "f954f0ff2c356ca94c89b38f1dbc7951b2187b237cff513916445614aeb8d7f9"

  bottle do
    sha256 "f0a8ae22f143d34efc15ebc94393b0d14ca835d5d832a39cb38f0947ab377f1d" => :high_sierra
    sha256 "f6c0d8cda858d78353ef904517532aa8949cdeae4e0d8afeeb11c8a6faa52ec9" => :sierra
    sha256 "a8e51cfb353e2b11dc266fc2ec59c2a1ba4f02d5cb1ced9a5fee12f7e09b9841" => :el_capitan
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
