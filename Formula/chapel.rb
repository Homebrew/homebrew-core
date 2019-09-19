class Chapel < Formula
  desc "Emerging programming language designed for parallel computing"
  homepage "https://chapel-lang.org/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.20.0/chapel-1.20.0.tar.gz"
  sha256 "08bc86df13e4ad56d0447f52628b0f8e36b0476db4e19a90eeb2bd5f260baece"

  bottle do
    sha256 "566175e438251b20ede1a382c3bf9adf6190a0795ddadbd424fa0e359ef587f8" => :mojave
    sha256 "20ae69dac7474ca917e4753b6c9e7ce1761c4b054f950abfad99fce05332fd52" => :high_sierra
    sha256 "f61ca08127d16681f68aabe1c1f6f0c695f4d557b1daa11c21ad06762359fb3f" => :sierra
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
      system "make", "test-venv"
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
      system "make", "check"
    end
  end
end
