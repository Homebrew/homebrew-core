class Chapel < Formula
  desc "Emerging programming language designed for parallel computing"
  homepage "https://chapel-lang.org/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.22.0/chapel-1.22.0.tar.gz"
  sha256 "57ba6ee5dfc36efcd66854ecb4307e1c054700ea201eff73012bd8b4572c2ce6"

  bottle do
    sha256 "296700c3496e0d1a1c9f15089da47a6fb6cd30a9ece155d7da217a106655b800" => :catalina
    sha256 "d787423d5898b796670e2cbe00280c5262d680e7ce422654ea259e47fe2777a4" => :mojave
    sha256 "89ce0beba7d80139b4f35c475b5a0fdc20c54fb9c5e2c18d5fb8c426ecaad5f5" => :high_sierra
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
