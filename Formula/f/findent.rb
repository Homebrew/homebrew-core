class Findent < Formula
  desc "Indent and beautify Fortran sources and generate dependency information"
  homepage "https://www.ratrabbit.nl/ratrabbit/findent/index.html"
  url "https://downloads.sourceforge.net/project/findent/findent-4.3.5.tar.gz"
  mirror "https://www.ratrabbit.nl/downloads/findent/findent-4.3.5.tar.gz"
  sha256 "5b2745eb5ec631726c31556d5e217df9fffb9109fa9a8db72363ee5bfff2a748"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/findent[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1793bef8942831b5e60fa3d4cbae7f8368c5dd3345b3bef9b3da94a1e1a2c71c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecf338fbc73cc11b02f8ddf5d5dd5504d6a33f670df7da24d27edbb6b143c0e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "04b0a36ee5fa80db79ecea4eca1e5cdb4fc69ba12ef69617d983f29aac997c3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "98b7b4b913ad6b8724d57e7749c212939ef616340fc294c86deb3dfca8b0b1a8"
    sha256 cellar: :any_skip_relocation, ventura:       "302c1a59b42c8ce7599be13172d8f18b3f42ebd900c2185f1fe47c1c44375555"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43836c1a6259b3fb7a38e665a414ce15b0d94208e5e7e5ee4043c326404fb26d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4cee623064bdf989314da5db602c9e57e205fec3bd35e3c1a3f9d46b7c121f8"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    (pkgshare/"test").install %w[test/progfree.f.in test/progfree.f.try.f.ref]
  end

  test do
    cp_r pkgshare/"test/progfree.f.in", testpath
    cp_r pkgshare/"test/progfree.f.try.f.ref", testpath

    flags = File.open(testpath/"progfree.f.in", &:readline).sub(/ *! */, "").chomp
    system bin/"findent #{flags} < progfree.f.in > progfree.f.out.f90"
    assert_path_exists testpath/"progfree.f.out.f90"
    assert compare_file(testpath/"progfree.f.try.f.ref", testpath/"progfree.f.out.f90")
  end
end
