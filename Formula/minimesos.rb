class Minimesos < Formula
  desc "Testing infrastructure for Mesos frameworks"
  homepage "https://minimesos.org/"
  url "https://github.com/ContainerSolutions/minimesos/archive/0.11.1.tar.gz"
  sha256 "75b3416ec1fb56ba809e9766efcdb75ae35fa753a016ae9912ab6fb2f29075e8"

  bottle :unneeded

  depends_on "docker"

  def install
    bin.install "bin/minimesos"
  end

  test do
    assert_match "Docker", shell_output("#{bin}/minimesos --help 2>&1", 1)
  end
end
