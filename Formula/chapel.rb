class Chapel < Formula
  desc "Emerging programming language designed for parallel computing"
  homepage "http://chapel.cray.com/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.15.0/chapel-1.15.0.tar.gz"
  sha256 "c7549124d90504027212a99176635b215ab11c12eadc995e89e7d019529d796f"
  head "https://github.com/chapel-lang/chapel.git"

  bottle do
    sha256 "df7074e302bb157e9eb54044a1bbf07639cca888badc6e57c5eed78412de4d15" => :sierra
    sha256 "b98d3a5b6bbdc0e117ce6b4706c6b4f14de294280c7d54494f6655234fb5734e" => :el_capitan
    sha256 "fb8d33a9926c574e025d74955164e9e2aadfe2a67099814e7089049d39b01bc6" => :yosemite
  end

  def install
    libexec.install Dir["*"]
    # Chapel uses this ENV to work out where to install.
    ENV["CHPL_HOME"] = libexec

    # Must be built from within CHPL_HOME to prevent build bugs.
    # https://github.com/Homebrew/legacy-homebrew/pull/35166
    cd libexec do
      system "make"
      system "make", "chpldoc"
      system "make", "test-venv"
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
