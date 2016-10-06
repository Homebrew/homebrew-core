class Chapel < Formula
  desc "Emerging programming language designed for parallel computing"
  homepage "http://chapel.cray.com/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.14.0/chapel-1.14.0.tar.gz"
  sha256 "9fbb3f4b446b4fd3b45572bd852964fe33de8eaeb3bac9b5c06b868181ba4059"
  head "https://github.com/chapel-lang/chapel.git"

  bottle do
    sha256 "73147dbbcbfac16399412ecfb12261e7af32f9a024811eeab6a974b0b8b56ba6" => :sierra
    sha256 "72d30fe0fb3c325bb6792dcc3cf52eecc9ce8d61d5d9664e4b48c0e2c17277d2" => :el_capitan
    sha256 "8d202021042a3a738547a238051e8435a48b03d6f73b715dd28abb24ce736f35" => :yosemite
    sha256 "fcd061dd0d1f4ebd5fd17d805f5c573dd12ead6fb770e927b932204cf9057fcf" => :mavericks
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
      system "make", "-C", "third-party", "clean"
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
