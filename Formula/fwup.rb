class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.15.0/fwup-0.15.0.tar.gz"
  sha256 "8dce471507e2109be769b0fda013ecabf8b8c44acb0beedb37b75b6da9a4ea7e"

  bottle do
    cellar :any
    sha256 "a1b630034ba2785dd3a7b8dc20ff30b227353c3175bab8a8ad851036f083e0cc" => :sierra
    sha256 "f11cf075d7c6554bb9a83b996463eda6aa8f003d91262e20cf9f568f6c17604b" => :el_capitan
    sha256 "2d23ccb5d92ea61c0c82854e8d0fa7d42631b5ddfa82ed408dab72bf5e34ccaf" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"
  depends_on "libarchive"
  depends_on "libsodium"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system bin/"fwup", "-g"
    assert File.exist?("fwup-key.priv"), "Failed to create fwup-key.priv!"
    assert File.exist?("fwup-key.pub"), "Failed to create fwup-key.pub!"
  end
end
