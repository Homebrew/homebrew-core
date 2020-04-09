class Chapel < Formula
  desc "Emerging programming language designed for parallel computing"
  homepage "https://chapel-lang.org/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.21.0/chapel-1.21.0.tar.gz"
  sha256 "886f7ba0e0e86c86dba99417e3165f90b1d3eca59c8cd5a7f645ce28cb5d82a0"

  bottle do
    sha256 "057e5c71d41f2ff71434f446ffd8f9aa932b553612313729d4651fdc58233650" => :catalina
    sha256 "8fcaebe6a3c465a29a66e691581b88b2fc9960726e1f94b3f21aa0f53c424044" => :mojave
    sha256 "4aee5a0ddf8a44897a2f03c458a8e7e70d76b07f04024119ed482fbc06cf330c" => :high_sierra
    sha256 "34a5eac538de8fb6ac632109a0154e1d14ff8551bc8f4fec8df8359568697338" => :sierra
  end

  def install
    libexec.install Dir["*"]
    # Chapel uses this ENV to work out where to install.
    ENV["CHPL_HOME"] = libexec
    # This is for mason
    ENV["CHPL_REGEXP"] = "re2"

    # Must be built from within CHPL_HOME to prevent build bugs.
    # https://github.com/Homebrew/legacy-homebrew/pull/35166
    cd libexec do
      system "make"
      system "make", "chpldoc"
      system "make", "mason"
      system "make", "cleanall"
    end

    prefix.install_metafiles

    # Install chpl and other binaries (e.g. chpldoc) into bin/ as exec scripts.
    bin.install Dir[libexec/"bin/darwin-x86_64/*"]
    bin.env_script_all_files libexec/"bin/darwin-x86_64/", :CHPL_HOME => libexec
    man1.install_symlink Dir["#{libexec}/man/man1/*.1"]
  end

  test do
    ENV["CHPL_HOME"] = libexec
    cd libexec do
      system "util/test/checkChplInstall"
    end
  end
end
