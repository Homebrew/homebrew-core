class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v1.8.1/fwup-1.8.1.tar.gz"
  sha256 "e7d41592e8d789e2534037cf375a1423db16826117e2938d459db325962b7b62"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "7e4291618515874555b38409501675df8d7302c6723cceebed8a8538350d283f" => :catalina
    sha256 "d31c8fa429f3225438f6fba7d54ea9ad48fa2373638c694a4e0e75a5f8ee1b0a" => :mojave
    sha256 "2fa7026d086a2bde8234f93375c24362038e2bf5950b8fa089772b77a2bdbf7f" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"
  depends_on "libarchive"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system bin/"fwup", "-g"
    assert_predicate testpath/"fwup-key.priv", :exist?, "Failed to create fwup-key.priv!"
    assert_predicate testpath/"fwup-key.pub", :exist?, "Failed to create fwup-key.pub!"
  end
end
