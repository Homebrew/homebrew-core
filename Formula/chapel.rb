class Chapel < Formula
  desc "Programming language for productive parallel computing at scale"
  homepage "https://chapel-lang.org/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.24.1/chapel-1.24.1.tar.gz"
  sha256 "f898f266fccaa34d937b38730a361d42efb20753ba43a95e5682816e008ce5e4"
  license "Apache-2.0"

  bottle do
    sha256 big_sur:      "e792266fb772218ca4acfc90910d4d26836e2c1fe1faa60ffc104bd7baf31046"
    sha256 catalina:     "7a06d32c992460337aa0af964803ace53465ecd90727c6ca57392017d5fb1890"
    sha256 mojave:       "c048b2189f4900731fbbfb76efc70bc8e4d85809759ac80b2de7bdeb6db76acf"
    sha256 x86_64_linux: "ca34ea32e25b7c9fea13bf25a09ac8b3151f45f8b8ac2dfeebfc0d18773783ba"
  end

  depends_on "python@3.9"

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
      rm_rf("third-party/llvm/llvm-src/")
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
