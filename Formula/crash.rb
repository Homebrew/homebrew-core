class Crash < Formula
  desc "Kernel debugging shell for Java that allows gdb-like syntax"
  homepage "https://www.crashub.org/"
  url "https://search.maven.org/remotecontent?filepath=org/crashub/crash.distrib/1.3.2/crash.distrib-1.3.2.tar.gz"
  sha256 "9607a84c34b01e5df999ac5bde6de2357d2a0dfb7c5c0ce2a5aea772b174ef01"

  livecheck do
    url "https://github.com/crashub/crash"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d53855b2b1ebbce661c375de30be8fac5b586385927c1f10dea03625532b3746"
  end

  resource "docs" do
    url "https://search.maven.org/remotecontent?filepath=org/crashub/crash.distrib/1.3.2/crash.distrib-1.3.2-docs.tar.gz"
    sha256 "b3bf1efe50fb640224819f822835e3897c038ab5555049f2279a5b26171178bb"
  end

  def install
    doc.install resource("docs")
    libexec.install Dir["crash/*"]
    bin.install_symlink "#{libexec}/bin/crash.sh"
  end
end
