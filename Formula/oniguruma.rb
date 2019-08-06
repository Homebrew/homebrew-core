class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.9.3/onig-6.9.3.tar.gz"
  sha256 "ab5992a76b7ab2185b55f3aacc1b0df81132c947b3d594f82eb0b41cf219725f"

  bottle do
    cellar :any
    sha256 "f00f8c6f8afd8875fed685a9190cb0c5e9b5ceef58ef1e489fb17a42bddc9672" => :mojave
    sha256 "42f48f03fc7030dcdcd15b920e863c107982cabfc063e3ccb60032e31b01562c" => :high_sierra
    sha256 "67a2105211f270ed618fdb3d29946ad89e2cb6e7bbb5cbb7dc7f48bc4e94e6db" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{prefix}/, shell_output("#{bin}/onig-config --prefix")
  end
end
