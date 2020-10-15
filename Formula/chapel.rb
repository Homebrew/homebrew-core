class Chapel < Formula
  desc "Emerging programming language designed for parallel computing"
  homepage "https://chapel-lang.org/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.22.1/chapel-1.22.1.tar.gz"
  sha256 "8235eb0869c9b04256f2e5ce3ac4f9eff558401582fba0eba05f254449a24989"
  license "Apache-2.0"

  bottle do
    sha256 "aa7c3e7f089ac71f88c51eb06d0551d78661cb4fadaa86d9807a908c45650df8" => :catalina
    sha256 "e722faf3c5f799150134f179d81733830b9b838812bdec77d350e0f752f71a5e" => :mojave
    sha256 "9ba754a9f0788efe6ff78a6218773a915078ef798c2a9c72defa12ff18374fd1" => :high_sierra
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
    bin.env_script_all_files libexec/"bin/darwin-x86_64/", CHPL_HOME: libexec
    man1.install_symlink Dir["#{libexec}/man/man1/*.1"]
  end

  test do
    ENV["CHPL_HOME"] = libexec
    cd libexec do
      system "util/test/checkChplInstall"
    end
  end
end
