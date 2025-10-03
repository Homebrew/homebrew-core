class Crash < Formula
  desc "Kernel debugging shell for Java that allows gdb-like syntax"
  homepage "https://www.crashub.org/"
  url "https://search.maven.org/remotecontent?filepath=org/crashub/crash.distrib/1.3.2/crash.distrib-1.3.2.tar.gz"
  sha256 "9607a84c34b01e5df999ac5bde6de2357d2a0dfb7c5c0ce2a5aea772b174ef01"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/crashub/crash.distrib/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f2b6a3446992c7b2b38b4db049afc77e08c1eeaa3780d12686e298d4f705420b"
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
