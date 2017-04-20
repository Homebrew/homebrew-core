class NoMoreSecrets < Formula
  desc "Recreates the SETEC ASTRONOMY effect from 'Sneakers'"
  homepage "https://github.com/bartobri/no-more-secrets"
  url "https://github.com/bartobri/no-more-secrets/archive/v0.3.2.tar.gz"
  sha256 "8afe8e78869df399e9597e549a49b6e11ec010742ebf186c3975a7825c6cbf02"

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
