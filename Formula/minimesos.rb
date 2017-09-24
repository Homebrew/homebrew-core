class Minimesos < Formula
  desc "Testing infrastructure for Mesos frameworks"
  homepage "https://minimesos.org/"
  url "https://github.com/ContainerSolutions/minimesos/archive/0.13.0.tar.gz"
  sha256 "806a2e7084d66431a706e365814fca8603ba64780ac6efc90e52cbf7ef592250"

  bottle :unneeded

  depends_on "docker"

  def install
    bin.install "bin/minimesos"
  end

  test do
    assert_match "Docker", shell_output("#{bin}/minimesos --help 2>&1", 1)
  end
end
