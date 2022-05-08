class Kore < Formula
  desc "Web application framework for writing web APIs in C"
  homepage "https://kore.io/"
  url "https://kore.io/releases/kore-4.2.2.tar.gz"
  sha256 "77c12d80bb76fe774b16996e6bac6d4ad950070d0816c3409dc0397dfc62725f"
  license "ISC"
  revision 1
  head "https://github.com/jorisvink/kore.git", branch: "master"

  livecheck do
    url "https://kore.io/source"
    regex(/href=.*?kore[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "27798ed9c1b2a244c3fa3e761e144355f2a076705e010b59e08bb42a0719008c"
    sha256 arm64_big_sur:  "39db88c4d055465051a2846f355cb38fc325a1b112247e1e79599e8122109b40"
    sha256 monterey:       "604404ff3fe51efa49e3b9f94149828c9d42b6d096e47eee029deb3d6b21489e"
    sha256 big_sur:        "53662ab03e15d19f7fb230017a145c307aab2499e1a47c035cdad9ff39bdce01"
    sha256 catalina:       "d8a80ba22d2ffad6156375e5e186ad028241157f03b0b3bf182e38459b552367"
    sha256 x86_64_linux:   "a17fc962fc354caae564ddaf37e6e5209287c91fb503bd9a5a8e50a031934dd3"
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
