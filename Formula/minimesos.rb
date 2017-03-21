class Minimesos < Formula
  desc "Testing infrastructure for Mesos frameworks"
  homepage "https://minimesos.org/"
  url "https://github.com/ContainerSolutions/minimesos/archive/0.13.0.tar.gz"
  sha256 "4e510b734d025a806bcbe2e613d4057e3456809473bd1bb665d5244f02b44dcc"

  bottle :unneeded

  depends_on "docker"

  def install
    bin.install "bin/minimesos"
  end

  test do
    assert_match "Docker", shell_output("#{bin}/minimesos --help 2>&1", 1)
  end
end
