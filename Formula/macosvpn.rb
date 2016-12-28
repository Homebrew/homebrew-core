class Macosvpn < Formula
  desc "Create Mac OS VPNs programmatically"
  homepage "https://github.com/halo/macosvpn"
  url "https://github.com/halo/macosvpn/archive/0.3.1.tar.gz"
  sha256 "b0bb49c9bdbaf678f6017f5be14abffaf12b7dbcc8174e12b3e15e3ef04c17a3"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a3493abd5142c5525575af3788c6945dc485835c9cc0eb8408cb4cd48fc02a2" => :sierra
    sha256 "c9ee2bb00664be8afbf7456aaf866c959b0d382bfc11d51abc1d52a84ecb7f38" => :el_capitan
  end

  depends_on :xcode => ["7.3", :build]

  def install
    xcodebuild
    bin.install "build/Release/macosvpn"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macosvpn version", 98)
  end
end
