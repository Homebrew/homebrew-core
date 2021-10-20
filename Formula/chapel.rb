class Chapel < Formula
  desc "Programming language for productive parallel computing at scale"
  homepage "https://chapel-lang.org/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.25.0/chapel-1.25.0.tar.gz"
  sha256 "39f43fc6de98e3b1dcee9694fdd4abbfb96cc941eff97bbaa86ee8ad88e9349b"
  license "Apache-2.0"

  bottle do
    sha256 big_sur:      "beda2be8596ab9a15e88cbd19c5b0289ab15b88d7f63c56d61bb863137276c7a"
    sha256 catalina:     "f4a653976006f3f5c54b57ebada3527f807af9cbc69713591945fa7003a89927"
    sha256 mojave:       "6be57e2cd756b5cb822bf87ab069bea4915b42c141cda9865b6279c45917c6fb"
    sha256 x86_64_linux: "9b1816e66d41d06e9be28682a8282c12280e228ed631aad2d97e479f2e006779"
  end

  depends_on "llvm@11"
  depends_on "python@3.9"

  def install
    libexec.install Dir["*"]
    # Chapel uses this ENV to work out where to install.
    ENV["CHPL_HOME"] = libexec
    # This is for mason
    ENV["CHPL_RE2"] = "bundled"

    # Must be built from within CHPL_HOME to prevent build bugs.
    # https://github.com/Homebrew/legacy-homebrew/pull/35166
    cd libexec do
      system "./util/printchplenv", "--all"
      system "make"
      # Need to let chapel choose target compiler with llvm
      ENV["CHPL_HOST_CC"] = ENV["CC"]
      ENV["CHPL_HOST_CXX"] = ENV["CXX"]
      ENV.delete("CC")
      ENV.delete("CXX")
      system "./util/printchplenv", "--all"
      system "make"
      system "make", "chpldoc"
      system "make", "mason"
      system "make", "cleanall"
      rm_rf("third-party/llvm/llvm-src/")
      rm_rf("third-party/gasnet/gasnet-src")
      rm_rf("third-party/libfabric/libfabric-src")
      rm_rf("third-party/fltk/fltk-1.3.5-source.tar.gz")
      rm_rf("third-party/libunwind/libunwind-1.1.tar.gz")
    end

    prefix.install_metafiles

    # Install chpl and other binaries (e.g. chpldoc) into bin/ as exec scripts.
    platform = if OS.mac?
      "darwin-x86_64"
    elsif Hardware::CPU.is_64_bit?
      "linux64-x86_64"
    else
      "linux-x86_64"
    end

    bin.install Dir[libexec/"bin/#{platform}/*"]
    bin.env_script_all_files libexec/"bin/#{platform}/", CHPL_HOME: libexec
    man1.install_symlink Dir["#{libexec}/man/man1/*.1"]
  end

  test do
    ENV["CHPL_HOME"] = libexec
    cd libexec do
      system "util/test/checkChplInstall"
    end
  end
end
