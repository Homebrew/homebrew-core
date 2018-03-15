class Chapel < Formula
  desc "Emerging programming language designed for parallel computing"
  homepage "http://chapel.cray.com/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.16.0/chapel-1.16.0.tar.gz"
  sha256 "5748431119d17c8a864162194797679ca3772eb2ee251eee4369afc2ed024b95"
  head "https://github.com/chapel-lang/chapel.git"

  bottle do
    sha256 "aef33e77ac7a768aa247a0197e807b826bd4ab6477e86fb8842fc30e66d513ac" => :high_sierra
    sha256 "8865b2220f717d719e9d7ead254dc85ac90b912d121cffe1b32bde5f19f7e374" => :sierra
    sha256 "76c77426a0eb19f236a318428dcae598ae718a71380969795d151c06542c96f9" => :el_capitan
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
