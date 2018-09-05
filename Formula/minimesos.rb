class Minimesos < Formula
  desc "Testing infrastructure for Mesos frameworks"
  homepage "https://minimesos.org/"
  url "https://github.com/ContainerSolutions/minimesos/archive/0.13.0.tar.gz"
  sha256 "806a2e7084d66431a706e365814fca8603ba64780ac6efc90e52cbf7ef592250"
  revision 1

  bottle :unneeded

  def install
    bin.install "bin/minimesos"
  end

  test do
    output = shell_output("#{bin}/minimesos --help 2>&1", 127)
    assert_match "docker: command not found", output
  end
end
