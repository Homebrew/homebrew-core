class Flawfinder < Formula
  desc "Examines code and reports possible security weaknesses"
  homepage "https://www.dwheeler.com/flawfinder/"
  url "https://www.dwheeler.com/flawfinder/flawfinder-2.0.4.tar.gz"
  sha256 "43ffe3bd19cafbc4f24c53c6d80810297ebfbf9a72b693e58e59775813ee66ec"

  head "https://git.code.sf.net/p/flawfinder/code.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ce1dbcf1966511728bb4bffd74c00391835f2b2e10f51984546ebdde6f32879" => :high_sierra
    sha256 "3ce1dbcf1966511728bb4bffd74c00391835f2b2e10f51984546ebdde6f32879" => :sierra
    sha256 "3ce1dbcf1966511728bb4bffd74c00391835f2b2e10f51984546ebdde6f32879" => :el_capitan
  end

  resource "flaws" do
    url "https://www.dwheeler.com/flawfinder/test.c"
    sha256 "4a9687a091b87eed864d3e35a864146a85a3467eb2ae0800a72e330496f0aec3"
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    resource("flaws").stage do
      assert_match "Hits = 36",
                   shell_output("#{bin}/flawfinder test.c")
    end
  end
end
