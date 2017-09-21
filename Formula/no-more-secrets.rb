class NoMoreSecrets < Formula
  desc "Recreates the SETEC ASTRONOMY effect from 'Sneakers'"
  homepage "https://github.com/bartobri/no-more-secrets"
  url "https://github.com/bartobri/no-more-secrets/archive/v0.3.3.tar.gz"
  sha256 "cfcf408768c6b335780e46a84fbc121a649c4b87e0564fc972270e96630efdce"

  bottle do
    cellar :any_skip_relocation
    sha256 "307c1dc639091d2ceced5aae6aff14ce504bbbd656cdf10a0945eb20e4848917" => :sierra
    sha256 "862d03ffdb5b87f42513c2453d3e33fb949d52140828510f38038fed89c34fec" => :el_capitan
    sha256 "89f48062d7f752f92df4880397e7f78d0eb11d8f1394560a2131d8892fcabcf2" => :yosemite
  end

  def install
    system "make", "all"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    assert_equal "nms version #{version}", shell_output("#{bin}/nms -v").chomp
  end
end
