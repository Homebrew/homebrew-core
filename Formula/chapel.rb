class Chapel < Formula
  desc "Emerging programming language designed for parallel computing"
  homepage "https://chapel-lang.org/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.24.0/chapel-1.24.0.tar.gz"
  sha256 "77c6087f3e0837268470915f2ad260d49cf7ac4adf16f5b44862ae624c1be801"
  license "Apache-2.0"

  bottle do
    sha256 big_sur:  "31a99c8d05a4f7b15fe4304e28c19afc649d383f3067cec248e1b53e83aa419e"
    sha256 catalina: "0a8b6f467f3bcc5e3c8c9f5f6f4bf69224df6fdd63c930b6638f393194e474fd"
    sha256 mojave:   "8a9bb9ed268f74bf9fac32456b36a73847e6f98aea8e0c8c76531c2aad5356a4"
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
    end

    prefix.install_metafiles

    # Install chpl and other binaries (e.g. chpldoc) into bin/ as exec scripts.
    platform = "darwin-x86_64"

    on_linux do
      platform = Hardware::CPU.is_64_bit? ? "linux64-x86_64" : "linux-x86_64"
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
