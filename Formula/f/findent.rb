class Findent < Formula
  desc "Indent and beautify Fortran sources and generate dependency information"
  homepage "https://www.ratrabbit.nl/ratrabbit/findent/index.html"
  url "https://downloads.sourceforge.net/project/findent/findent-4.3.6.tar.gz"
  mirror "https://www.ratrabbit.nl/downloads/findent/findent-4.3.6.tar.gz"
  sha256 "72d834d8ff0fdd1dbb942a6fded20b499e62927d956b6e631ce588b917c838d4"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/findent[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7675b6946e4f800633e9453086e0b74087328099ff1b0da2c563727f057d3b5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b83d0117f6283f33b02fe1e9e933e76ac5f58c270222ab843a73dbb59f7a2df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88f9f18aa6178b9a83965631dae52e91eca3b6a842803b0abe522d36a642f5ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "073bcdad4e8d4394e14aca37bf5334a443a2814735120f07bcec402d6e511222"
    sha256 cellar: :any_skip_relocation, sonoma:        "a87271f8c35ab27b430e7b9098478844f1b7b108d35dc139a1a1c9d4a2f87f0e"
    sha256 cellar: :any_skip_relocation, ventura:       "07a1b42a55e3ccebb2d672ad194000ac187a52dfdfb391636e910651b153f0c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad9bd5159bcc677061bee187513b011454123ec3070d82e1106b63df17fce442"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81c96ff0ab4ed60977f2dc5f33c452238560311068d3e841becf7e5e13764e8b"
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
