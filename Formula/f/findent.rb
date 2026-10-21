class Findent < Formula
  desc "Indent and beautify Fortran sources and generate dependency information"
  homepage "https://www.ratrabbit.nl/ratrabbit/findent/index.html"
  url "https://downloads.sourceforge.net/project/findent/findent-4.4.2.tar.gz"
  mirror "https://www.ratrabbit.nl/downloads/findent/findent-4.4.2.tar.gz"
  sha256 "005a0a8cb8e25c8aab10ba3e0735a26b00835281040ee4d3453580ca8604e078"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/findent[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e24bd6c232ba9d7b301aa0d4ddb9541971ab2446189dfcb9507b7be56cadfba7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "61c9de86f9854291e128eb29e62be7f6717e74e2db83a511d42202c9d1c335e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2f9f4389e3e092320a864d2952c6ccf3e5f43e87de843e73b6d02c457ca9ffbd"
    sha256 cellar: :any,                 arm64_linux:       "c88e4b623209f2a769d7feee8d35d2671591a3e63d16487470e9219d7a110cda"
    sha256 cellar: :any,                 x86_64_linux:      "a988cfa29e896820e533174e7103ae459974067130ea7d44779039971467a6b2"
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
