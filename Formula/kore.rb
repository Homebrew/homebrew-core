class Kore < Formula
  desc "Web application framework for writing web APIs in C"
  homepage "https://kore.io/"
  url "https://kore.io/releases/kore-4.2.1.tar.gz"
  sha256 "f76b108a4eefa27c89123f5d6a36b493b171e429be7a85d3dd1466ac87e7f15a"
  license "ISC"
  head "https://github.com/jorisvink/kore.git", branch: "master"

  livecheck do
    url "https://kore.io/source"
    regex(/href=.*?kore[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "d699c224f9e13a1d5bc20e0f6e98d469e8b7a8036ed28a1459972fea323a666a"
    sha256 arm64_big_sur:  "78fb0e516c43a86d7084dd68cf9bf0ff858df862c8ae5927bab95cf857a26665"
    sha256 monterey:       "f26a487e086bd7d73eab1e81795848e2b9695c776df35042e19e979f4ff85e6d"
    sha256 big_sur:        "a7bc39e7560ba3b56ade55247251b23050521a0d8e7d2c55944426ea0aa644e8"
    sha256 catalina:       "2cfb4d82a30a171a4778ac07cf8c0e94a3dd1004960ba17fd76935f661e298d0"
    sha256 x86_64_linux:   "2c9c5cec0e9edda2e8f7e03a4ba735eba206280f6d19f2b2d7ba896000637e07"
  end

  depends_on "pkg-config" => :build
  depends_on macos: :sierra # needs clock_gettime
  depends_on "openssl@1.1"

  def install
    ENV.deparallelize { system "make", "PREFIX=#{prefix}", "TASKS=1" }
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"kodev", "create", "test"
    cd "test" do
      system bin/"kodev", "build"
      system bin/"kodev", "clean"
    end
  end
end
