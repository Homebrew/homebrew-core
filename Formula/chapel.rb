class Chapel < Formula
  desc "Emerging programming language designed for parallel computing"
  homepage "http://chapel.cray.com/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.14.0/chapel-1.14.0.tar.gz"
  sha256 "9fbb3f4b446b4fd3b45572bd852964fe33de8eaeb3bac9b5c06b868181ba4059"
  head "https://github.com/chapel-lang/chapel.git"

  bottle do
    sha256 "4f7d25c2fada020463d1280eb8f6eb757fffe333acdc58ade1a42849f06be533" => :sierra
    sha256 "264b2c2ad4803ca7c96b2363cfab0bfccbe3537b7a2ae54dffa68acecfa85ef6" => :el_capitan
    sha256 "77b06d3c50a75a295e7bdce5da7863809b35f22718db86c85a60feb3bcbf766b" => :yosemite
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
