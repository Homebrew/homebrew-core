class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.9.3/onig-6.9.3.tar.gz"
  sha256 "ab5992a76b7ab2185b55f3aacc1b0df81132c947b3d594f82eb0b41cf219725f"

  bottle do
    cellar :any
    sha256 "c613befafe81da48913ebd1a7eb036a7d8a147516fae32e2fbf4278efdb34056" => :mojave
    sha256 "ea9b09c3567f1315153e44245ae033bb0d101b2c59cd6af304073c8b120e874c" => :high_sierra
    sha256 "417c389300b18a9e5ad94e80c7e8129d9cc68ec2eeb6c8e7b00e45f7c4e9e21b" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{prefix}/, shell_output("#{bin}/onig-config --prefix")
  end
end
