class Chapel < Formula
  desc "Emerging programming language designed for parallel computing"
  homepage "http://chapel.cray.com/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.13.1/chapel-1.13.1.tar.gz"
  sha256 "9745c313548df610da2a6a3e920526baba92f11737c38fbeffd4de7bef5c011f"
  head "https://github.com/chapel-lang/chapel.git"

  bottle do
    sha256 "c894182491763d53c8a4f8cf9f0596360dd2950a12be0675523152747f551be2" => :el_capitan
    sha256 "8cace8d42b8ab5123445efedb5ba2273de56b3f639222c5262dcebc6df1c94a2" => :yosemite
    sha256 "b08dd7f10e37ee603ae3c27d4a26cdeec5de03a1875fd9cec26cd94b59cb0820" => :mavericks
  end

  def install
    libexec.install Dir["*"]
    # Chapel uses this ENV to work out where to install.
    ENV["CHPL_HOME"] = libexec

    # Must be built from within CHPL_HOME to prevent build bugs.
    # https://gist.github.com/DomT4/90dbcabcc15e5d4f786d
    # https://github.com/Homebrew/homebrew/pull/35166
    cd libexec do
      system "make"
      system "make", "chpldoc"
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
