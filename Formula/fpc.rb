class Fpc < Formula
  desc "Free Pascal: multi-architecture Pascal compiler"
  homepage "https://www.freepascal.org/"
  url "https://downloads.sourceforge.net/project/freepascal/Source/3.2.2/fpc-3.2.2.source.tar.gz"
  sha256 "d542e349de246843d4f164829953d1f5b864126c5b62fd17c9b45b33e23d2f44"
  license "GPL-2.0-or-later"

  # fpc releases involve so many files that the tarball is pushed out of the
  # RSS feed and we can't rely on the SourceForge strategy.
  livecheck do
    url "https://sourceforge.net/projects/freepascal/files/Source/"
    strategy :page_match
    regex(%r{href=(?:["']|.*?Source/)?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b6a8dd5b23132c110efda34b59aaaeeebaf509e72dd1d4f621b07d97fe99ec17"
    sha256 cellar: :any, big_sur:       "9d41a4f67a0850724a81ad507d155a2874132fc6f9af076485ffbb38bfcb8fb4"
    sha256 cellar: :any, catalina:      "609f7ebf13e5986764661d44044cac9e66ca327f4247def6d395eb4f35a1ff96"
    sha256 cellar: :any, mojave:        "9d1cca864137ed5eca91156d76dc8005034739a21c23d667774b349a87d90cd9"
  end

  resource "bootstrap" do
    url "https://downloads.sourceforge.net/project/freepascal/Mac%20OS%20X/3.0.4/fpc-3.0.4a.intel-macosx.dmg"
    sha256 "56b870fbce8dc9b098ecff3c585f366ad3e156ca32a6bf3b20091accfb252616"
  end

  def install
    fpc_bootstrap = buildpath/"bootstrap"
    resource("bootstrap").stage do
      system "pkgutil", "--expand-full", "fpc-3.0.4a.intel-macosx.pkg", "contents"
      (fpc_bootstrap/"fpc-3.0.4a").install Dir["contents/fpc-3.0.4a.intel-macosx.pkg/Payload/usr/local/*"]
    end
    fpc_compiler = fpc_bootstrap/"fpc-3.0.4a/bin/ppcx64"

    # Help fpc find the startup files (crt1.o and friends) with 10.14 SDK
    args = (MacOS.version >= :mojave) ? ['OPT="-XR/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk"'] : []

    system "make", "build", "PP=#{fpc_compiler}", *args
    system "make", "install", "PP=#{fpc_compiler}", "PREFIX=#{prefix}"

    bin.install_symlink lib/"#{name}/#{version}/ppcx64"

    # Prevent non-executable audit warning
    rm_f Dir[bin/"*.rsj"]

    # Generate a default fpc.cfg to set up unit search paths
    system "#{bin}/fpcmkcfg", "-p", "-d", "basepath=#{lib}/fpc/#{version}", "-o", "#{prefix}/etc/fpc.cfg"
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
    assert_equal "Hello Homebrew", `./hello`.strip
  end
end
