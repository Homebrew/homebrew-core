class Fpc < Formula
  desc "Free Pascal: multi-architecture Pascal compiler"
  homepage "https://www.freepascal.org/"
  url "https://downloads.sourceforge.net/project/freepascal/Source/3.2.2/fpc-3.2.2.source.tar.gz"
  sha256 "d542e349de246843d4f164829953d1f5b864126c5b62fd17c9b45b33e23d2f44"
  license "GPL-2.0-or-later"
  revision 1

  # fpc releases involve so many files that the tarball is pushed out of the
  # RSS feed and we can't rely on the SourceForge strategy.
  livecheck do
    url "https://sourceforge.net/projects/freepascal/files/Source/"
    regex(%r{href=(?:["']|.*?Source/)?v?(\d+(?:\.\d+)+)/?["' >]}i)
    strategy :page_match
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "580f3bdbf3f5578d13113ed8f65827f3d8136f7fb5793a9e80110074966961f1"
    sha256 cellar: :any, arm64_tahoe:       "83461758109bbaece09f36f9083f5e95f9be24c2d189de5f5551c0a0b36c1b5c"
    sha256 cellar: :any, arm64_sequoia:     "4f9b1d19a5fd90777cfffdb6b792054d408308735d4861e02795059accfd30c8"
    sha256 cellar: :any, arm64_linux:       "535ae21dc27a96e9160ae96766280db184f95ac515af3e634537b02d011e124d"
    sha256 cellar: :any, x86_64_linux:      "55961a517076fa7ab67805974379d6b82eddb3c4b9576650ec24bcbdccfba25e"
  end

  on_macos do
    depends_on "sevenzip" => :build # to extract the bootstrap dmg without `hdiutil`
  end

  # mesa is needed to test GL unit
  on_linux do
    depends_on "mesa" => :test
  end

  conflicts_with "px", because: "both install `ptop` binaries"

  resource "bootstrap" do
    on_macos do
      url "https://downloads.sourceforge.net/project/freepascal/Mac%20OS%20X/3.2.2/fpc-3.2.2.intelarm64-macosx.dmg", using: :nounzip
      sha256 "05d4510c8c887e3c68de20272abf62171aa5b2ef1eba6bce25e4c0bc41ba8b7d"
    end
    on_linux do
      on_arm do
        url "https://downloads.sourceforge.net/project/freepascal/Linux/3.2.2/fpc-3.2.2.aarch64-linux.tar"
        sha256 "b39470f9b6b5b82f50fc8680a5da37d2834f2129c65c24c5628a80894d565451"
      end
      on_intel do
        url "https://downloads.sourceforge.net/project/freepascal/Linux/3.2.2/fpc-3.2.2.x86_64-linux.tar"
        sha256 "5adac308a5534b6a76446d8311fc340747cbb7edeaacfe6b651493ff3fe31e83"
      end
    end
  end

  # Backport fix for arm64 linux
  patch do
    url "https://gitlab.com/freepascal.org/fpc/source/-/commit/a20a7e3497bccf3415bf47ccc55f133eb9d6d6a0.diff"
    sha256 "7fac043022a6f3ffa91287f856c2c4959fdc374ff9169a244eaf55a3897c76d8"
    type :backport
  end

  def install
    fpc_bootstrap = buildpath/"bootstrap"
    compiler_name = Hardware::CPU.arm? ? "ppca64" : "ppcx64"
    fpc_compiler = fpc_bootstrap/"bin"/compiler_name

    resource("bootstrap").stage do
      if OS.mac?
        # Extract the dmg with 7zz as the sandbox does not allow `hdiutil attach`
        system "7zz", "x", "-y", Dir["*.dmg"].first
        pkg_path = "fpc-3.2.2.intelarm64-macosx/fpc-3.2.2-intelarm64-macosx.mpkg/Contents/Packages/" \
                   "fpc-3.2.2-intelarm64-macosx.pkg"
        system "pkgutil", "--expand-full", pkg_path, "contents"
        fpc_bootstrap.install Dir["contents/Payload/usr/local/*"]
      else
        arch = Hardware::CPU.arm? ? "aarch64" : Hardware::CPU.arch.to_s
        mkdir "packages"
        system "tar", "-xf", "binary.#{arch}-linux.tar", "-C", "packages"
        mkdir_p fpc_bootstrap
        Dir["packages/*.tar.gz"].each do |tarball|
          system "tar", "-xzf", tarball, "-C", fpc_bootstrap
        end

        (fpc_bootstrap/"bin").install_symlink fpc_bootstrap/"lib/fpc/3.2.2"/compiler_name
      end
    end

    # Help fpc find the startup files (crt1.o and friends)
    args = if OS.mac? && (sdk = MacOS.sdk_for_formula(self).path)
      %W[OPT="-XR#{sdk}"]
    else
      []
    end

    system "make", "build", "PP=#{fpc_compiler}", *args
    system "make", "install", "PP=#{fpc_compiler}", "PREFIX=#{prefix}"

    bin.install_symlink lib/name/version/compiler_name

    # Prevent non-executable audit warning
    rm(Dir[bin/"*.rsj"])

    # Generate a default fpc.cfg to set up unit search paths
    system bin/"fpcmkcfg", "-p", "-d", "basepath=#{lib}/fpc/#{version}", "-o", prefix/"etc/fpc.cfg"

    if OS.linux?
      # On Linux, non-executable IDE support files get built and end up in bin.
      # Put them somewhere else instead.
      (pkgshare/"ide").install Dir[bin/"*.{ans,tdf,pt}"]

      # On Linux, config path is hard-coded to #{lib/name/version/compiler_name/"../etc"}
      # (or home directory or system-level /etc, neither of which are suitable for Homebrew)
      # so link #{prefix}/etc to where it can be found.
      (lib/"fpc").install_symlink prefix/"etc"
    end
  end

  test do
    (testpath/"hello.pas").write <<~PASCAL
      program Hello;
      uses GL;
      begin
        writeln('Hello Homebrew')
      end.
    PASCAL

    system bin/"fpc", "hello.pas"
    assert_equal "Hello Homebrew", shell_output("./hello").strip
  end
end
