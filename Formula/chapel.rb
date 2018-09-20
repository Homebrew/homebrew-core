class Chapel < Formula
  desc "Emerging programming language designed for parallel computing"
  homepage "https://chapel-lang.org/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.18.0/chapel-1.18.0.tar.gz"
  sha256 "68471e1f398b074edcc28cae0be26a481078adc3edea4df663f01c6bd3b6ae0d"

  bottle do
    sha256 "ec5a061a5bbb87ab2ae8914575754c21ff517438c87f34246f5407b03c05277b" => :mojave
    sha256 "a661717fffa4d53c89956e241fd830956a0b34c9ad6869a9fc0698918d0c1718" => :high_sierra
    sha256 "b884c781ec6b7feef055421be8518e43ce917cb0aada966a2a6e993df4eec162" => :sierra
    sha256 "703fd9c9a452a7d71bfe71d2c3ce5978ff1a95260e412857172ffbd91e5d829e" => :el_capitan
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
