class Chapel < Formula
  desc "Emerging programming language designed for parallel computing"
  homepage "https://chapel-lang.org/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.17.0/chapel-1.17.0.tar.gz"
  sha256 "7620b780cf2a2bd3b26022957c3712983519a422a793614426aed6d9d8bf9fab"
  head "https://github.com/chapel-lang/chapel.git"

  bottle do
    sha256 "b6127492018df19802de45be18718be4d4a46d4bc3c03e6a17aaf2886e554f34" => :high_sierra
    sha256 "c1009b64b0ef3b1fc3a1fa290baab42a84bcbf7009deade060c3931025da6745" => :sierra
    sha256 "0be54353a6e3b7553053173dfa0e4f1a606047ab1add1cd0e265dab07a9abc85" => :el_capitan
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
