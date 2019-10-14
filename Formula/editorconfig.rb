class Editorconfig < Formula
  desc "Maintain consistent coding style between multiple editors"
  homepage "https://editorconfig.org/"
  url "https://github.com/editorconfig/editorconfig-core-c/archive/v0.12.3.tar.gz"
  sha256 "64edf79500e104e47035cace903f5c299edba778dcff71b814b7095a9f14cbc1"
  head "https://github.com/editorconfig/editorconfig-core-c.git"

  bottle do
    cellar :any
    sha256 "a1315cb812fd1f626d7924543b80388f88e8cb13ee79e9f305d475bf5787217e" => :catalina
    sha256 "da824a4d67b8c1c1627d90e222b5f2441caf9cd7eca50de40380d3e7839db047" => :mojave
    sha256 "26eceb21fd8d34c04799f70ba22ca0da11456c1e3fa30b0b90e592038b840d01" => :high_sierra
    sha256 "a4655cde0acc92e11b02263337d384770bf0b592d828d44b8bef8be961572ad8" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pcre2"

  def install
    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/editorconfig", "--version"
  end
end
