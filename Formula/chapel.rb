class Chapel < Formula
  desc "Emerging programming language designed for parallel computing"
  homepage "https://chapel-lang.org/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.17.1/chapel-1.17.1.tar.gz"
  sha256 "f0a4671ca23832d69f831d230ca82264500ad1836d240854ba0835b95137f4f1"
  head "https://github.com/chapel-lang/chapel.git"

  bottle do
    sha256 "4d9a754da40ca8fed0a9ffbd93e8b7478484b3e62bbafc07d5e06a592665017d" => :mojave
    sha256 "1a9a4194ccfe50f46d30aa23d068f4284376778f82e9580dcf11139a107d173d" => :high_sierra
    sha256 "247b2f6bcfecee70f8fd20ef719fe0518d8f134ad7d3f7fd625e300cba955d86" => :sierra
    sha256 "2b19ead6fb70346cce7c2dbeb1ec1a64ae68f3044630f30a6a7b495b3548df6f" => :el_capitan
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
