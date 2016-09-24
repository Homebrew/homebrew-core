class Macosvpn < Formula
  desc "Create Mac OS VPNs programmatically"
  homepage "https://github.com/halo/macosvpn"
  url "https://github.com/halo/macosvpn/archive/0.3.0.tar.gz"
  sha256 "26fb049820f5fa63226609753d1ee2944e702c32e21230586659a1198091d7eb"

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
