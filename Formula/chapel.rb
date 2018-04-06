class Chapel < Formula
  desc "Emerging programming language designed for parallel computing"
  homepage "https://chapel-lang.org/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.17.0/chapel-1.17.0.tar.gz"
  sha256 "7620b780cf2a2bd3b26022957c3712983519a422a793614426aed6d9d8bf9fab"
  revision 1
  head "https://github.com/chapel-lang/chapel.git"

  bottle do
    sha256 "c6e13af8b2ad7eab4f306a6a72220320c192c1eb031d8cb13ad908e576e161f7" => :high_sierra
    sha256 "83fbf6e7fc929c3534f792eaa0fa1ff7e1eea9c7c735488196a106247a0ba013" => :sierra
    sha256 "821baa3760ace44d3cf06d13af0b20e3471bba0c62a5deda3ec4d7c14b4c5123" => :el_capitan
  end

  def install
    libexec.install Dir["*"]
    # Chapel uses this ENV to work out where to install.
    ENV["CHPL_HOME"] = libexec

    # Must be built from within CHPL_HOME to prevent build bugs.
    # https://github.com/Homebrew/legacy-homebrew/pull/35166
    cd libexec do
      system "make"
      system "make", "cleanall"
    end

    prefix.install_metafiles

    # Install chpl and other binaries (e.g. chpldoc) into bin/ as exec scripts.
    bin.install Dir[libexec/"bin/darwin/*"]
    bin.env_script_all_files libexec/"bin/darwin/", :CHPL_HOME => libexec
    man1.install_symlink Dir["#{libexec}/man/man1/*.1"]
  end

  test do
    ENV["CHPL_HOME"] = libexec
    cd libexec do
      system "make", "check"
    end
  end
end
