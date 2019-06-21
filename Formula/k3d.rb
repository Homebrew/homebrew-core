class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://github.com/rancher/k3d"
  url "https://github.com/rancher/k3d/archive/v1.2.1.tar.gz"
  sha256 "eb7510aab675183b7febbad79ee23e04de6e6e47369c898ccf03ec2022045709"

  bottle do
    cellar :any_skip_relocation
    sha256 "cecfd34ca55d4e7f898b8a80b511f076c1401a3a2ef3f632dc9ff47080eb1927" => :mojave
    sha256 "c88a94bf08b3db373dc91045d959c6dd1738260e0ed4c0ba3e43a588d13fb8b8" => :high_sierra
    sha256 "a66e222f3e3e22dc93cdfcec66f324e47f2512e5d348b837d6de9e218fe451a7" => :sierra
  end

  depends_on "go" => :build

  def install
    system "make", "BINDIR='#{bin}'", "GIT_TAG='#{version}'", "build"
  end

  test do
    system "#{bin}/k3d", "-v"
    assert_match "Checking docker...",
                 shell_output("#{bin}/k3d ct 2>&1", 1)
  end
end
