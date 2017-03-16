class Minimesos < Formula
  desc "Testing infrastructure for Mesos frameworks"
  homepage "https://minimesos.org/"
  url "https://github.com/ContainerSolutions/minimesos/archive/0.12.0.tar.gz"
  sha256 "0c79f31e37c1d9418125d4c8aa795bfdc2d29d01f516b91041f7212f97b7febd"

  bottle :unneeded

  depends_on "docker"

  def install
    bin.install "bin/minimesos"
  end

  test do
    assert_match "Docker", shell_output("#{bin}/minimesos --help 2>&1", 1)
  end
end
