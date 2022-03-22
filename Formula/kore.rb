class Kore < Formula
  desc "Web application framework for writing web APIs in C"
  homepage "https://kore.io/"
  url "https://kore.io/releases/kore-4.2.0.tar.gz"
  sha256 "3cc7d1a0d4a3b568bc15886cceebec208ebfd0a94293eaa3b275754d13c5445d"
  license "ISC"
  head "https://github.com/jorisvink/kore.git", branch: "master"

  livecheck do
    url "https://kore.io/source"
    regex(/href=.*?kore[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "2dddc35360c125666c7e9dcf9da34b38ce9c544ff232f7fd30788143f72714c4"
    sha256 arm64_big_sur:  "f096ed871959f72d0615082b84fb4f9b97ee8292c757c5997922cba56cd7ee63"
    sha256 monterey:       "466738c9a60c4bc270ce6230bd7ecbe5f7e9460a2e93e77a5e60dcde036675e1"
    sha256 big_sur:        "c72c788fddbab2c12e0fd1edf5f6fed06a3f3f1d83ad5315160f7fd3a014666a"
    sha256 catalina:       "261f345465acbc3c48419e076eaf6c599571936e831ce69d503c314f2d15b395"
    sha256 x86_64_linux:   "af7739d889d6170490c3e14ee85f5f90c65caa63b28b974376515352be3fb216"
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
