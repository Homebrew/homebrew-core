class Findent < Formula
  desc "Indent and beautify Fortran sources and generate dependency information"
  homepage "https://www.ratrabbit.nl/ratrabbit/findent/index.html"
  url "https://downloads.sourceforge.net/project/findent/findent-4.3.4.tar.gz"
  sha256 "ca5c7dbdb79eab0499fd66bcaa18f5191f3dc3ff310ccfe78f597f12eda93e73"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/findent[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df68a325da3ad5cbe46895b59ebd2ba23bbf8a753c9b7f8651c2d14b15c533dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b7eb9586ca10c6d0a523d139df241b812561fec29e3fbab4967452351c01cde"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54e4c057c543dd277584ca034aea033ea176876ee8bde6b65353f9e533146dc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a16b402c86abc424821f357ed16735a154e317469bf3616681a5f7777e2f5b2"
    sha256 cellar: :any_skip_relocation, ventura:       "0dbae6a73221d220649cf339511895f15910d463689545130de97c0422566167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5eacc1629f587c27e05a14b42e83eda8cf769e39fd89b2102bbd0e7cd4a5cc32"
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
    assert_predicate testpath/"progfree.f.out.f90", :exist?
    assert compare_file(testpath/"progfree.f.try.f.ref", testpath/"progfree.f.out.f90")
  end
end
