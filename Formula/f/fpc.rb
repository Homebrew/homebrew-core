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
    sha256 cellar: :any,                 arm64_sonoma:   "e480e9fed8fc823d817fd3178b9eea9c3ca5da5b1d6c6c55d69622cf5ecca411"
    sha256 cellar: :any,                 arm64_ventura:  "4b97cd1a7cb634a76fdf735018cb18304fb185628a99dfd58ea72b137df7b14e"
    sha256 cellar: :any,                 arm64_monterey: "86f02cead2ca01e961c47442b79a5b9d4703194d3f436b91fefc56fefe859081"
    sha256 cellar: :any,                 arm64_big_sur:  "b4efbb9f568afadfb27aab8ca80895b7f306f58c7ff8a0623f2bd8418338b745"
    sha256 cellar: :any,                 sonoma:         "c5fb604a561ff84c67c6a93f2be94adf6f74b7ddbeb9cdfc1def6929ed2a8e59"
    sha256 cellar: :any,                 ventura:        "fbc1ab1898d436b128697c853bdd6807b05fdbcff4636a61733a711ceef56039"
    sha256 cellar: :any,                 monterey:       "42f981be67bc5f3a433117e3ae4b014001aa786acb4a24d09579fc154beedb4d"
    sha256 cellar: :any,                 big_sur:        "4c3a012398b6136776358206b0cac52ec1096484c27a08c142e7f51afc713956"
    sha256 cellar: :any,                 catalina:       "1bbaa4c1b6a616f8a56554b30c69cae267d22849074eb628d77c23af2e911e6e"
    sha256 cellar: :any,                 mojave:         "314265a7bff5c2f8a613d1c04db8856f6523d8d00d33435892260ef3fa9cc604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3491933cdf5782d3c4b9b1188757cb3846b5d823a6db75c8fb56f13b23bc6747"
  end

  # mesa is needed to test GL unit
  on_linux do
    depends_on "mesa" => :test
  end

  resource "bootstrap" do
    on_macos do
      url "https://downloads.sourceforge.net/project/freepascal/Mac%20OS%20X/3.2.2/fpc-3.2.2.intelarm64-macosx.dmg"
      sha256 "05d4510c8c887e3c68de20272abf62171aa5b2ef1eba6bce25e4c0bc41ba8b7d"
    end

    on_linux do
      url "https://downloads.sourceforge.net/project/freepascal/Linux/3.2.2/fpc-3.2.2.x86_64-linux.tar"
      sha256 "5adac308a5534b6a76446d8311fc340747cbb7edeaacfe6b651493ff3fe31e83"
    end
  end

  def install
    fpc_bootstrap = buildpath/"bootstrap"
    compiler_name = Hardware::CPU.arm? ? "ppca64" : "ppcx64"
    fpc_compiler = fpc_bootstrap/"bin"/compiler_name

    resource("bootstrap").stage do
      if OS.mac?
        pkg_path = "fpc-3.2.2-intelarm64-macosx.mpkg/Contents/Packages/fpc-3.2.2-intelarm64-macosx.pkg"
        system "pkgutil", "--expand-full", pkg_path, "contents"
        fpc_bootstrap.install Dir["contents/Payload/usr/local/*"]
      else
        mkdir "packages"
        system "tar", "-xf", "binary.x86_64-linux.tar", "-C", "packages"
        mkdir_p fpc_bootstrap
        Dir["packages/*.tar.gz"].each do |tarball|
          system "tar", "-xzf", tarball, "-C", fpc_bootstrap
        end

        (fpc_bootstrap/"bin").install_symlink fpc_bootstrap/"lib/fpc/3.2.2"/compiler_name
      end
    end

    # Help fpc find the startup files (crt1.o and friends)
    args = if OS.mac? && (sdk = MacOS.sdk_path_if_needed)
      %W[OPT="-XR#{sdk}"]
    else
      []
    end

    system "make", "build", "PP=#{fpc_compiler}", *args
    system "make", "install", "PP=#{fpc_compiler}", "PREFIX=#{prefix}"

    bin.install_symlink lib/name/version/compiler_name

    # Prevent non-executable audit warning
    rm_f Dir[bin/"*.rsj"]

    # Generate a default fpc.cfg to set up unit search paths
    system "#{bin}/fpcmkcfg", "-p", "-d", "basepath=#{lib}/fpc/#{version}", "-o", "#{prefix}/etc/fpc.cfg"

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
    hello = <<~EOS
      program Hello;
      uses GL;
      begin
        writeln('Hello Homebrew')
      end.
    EOS
    (testpath/"hello.pas").write(hello)
    system "#{bin}/fpc", "hello.pas"
    assert_equal "Hello Homebrew", shell_output("./hello").strip
  end
end
