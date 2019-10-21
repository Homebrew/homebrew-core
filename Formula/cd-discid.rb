class CdDiscid < Formula
  desc "Read CD and get CDDB discid information"
  homepage "http://linukz.org/cd-discid.shtml"
  revision 2
  head "https://github.com/taem/cd-discid.git"

  stable do
    url "http://linukz.org/download/cd-discid-1.4.tar.gz"
    mirror "https://deb.debian.org/debian/pool/main/c/cd-discid/cd-discid_1.4.orig.tar.gz"
    sha256 "ffd68cd406309e764be6af4d5cbcc309e132c13f3597c6a4570a1f218edd2c63"

    # macOS fix; see https://github.com/Homebrew/homebrew/issues/46267
    # Already fixed in upstream head; remove when bumping version to >1.4
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/cd-discid/1.4.patch"
      sha256 "f53b660ae70e91174ab86453888dbc3b9637ba7fcaae4ea790855b7c3d3fe8e6"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0a9f85136e9727175a4d861f759236d62cf24f19170e27bfd9bf8aeddbc4c8b3" => :catalina
    sha256 "158d91563b2e79574c0a336f775b49033d85ce3b290f122dae853dea45841f5b" => :mojave
    sha256 "26b88be0312f960484625161d94adf9a44aa88ef5817ba28b61af520a6e17e03" => :high_sierra
    sha256 "6b0d9c55a1adfce8a2c6e9eabd00c37118a05b60678564e7a9695d876bca117b" => :sierra
    sha256 "f0c17cfc3c345c661104a6f29562b766cac2a80747feea0c26cda04ece3c8326" => :el_capitan
    sha256 "3331be095997a1e5e6acb9f82f5e5473ed51c0f35976229371dc1d0c703c2e3b" => :yosemite
    sha256 "86f0066d344a2a0a37e3c00d08255d4a505b41cc2c38e7d33ac643d16af8ad71" => :mavericks
  end

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "cd-discid"
    man1.install "cd-discid.1"
  end

  test do
    assert_equal "cd-discid #{version}.", shell_output("#{bin}/cd-discid --version 2>&1").chomp
  end
end
