class Fpc < Formula
  desc "Free Pascal: multi-architecture Pascal compiler"
  homepage "https://www.freepascal.org/"
  url "https://downloads.sourceforge.net/project/freepascal/Source/3.2.0/fpc-3.2.0.source.tar.gz"
  sha256 "d595b72de7ed9e53299694ee15534e5046a62efa57908314efa02d5cc3b1cf75"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any
    sha256 "67c263ba003c8b7c5632d2417c9431a8ebb4ff5760f3e495f326f1879d2a7670" => :catalina
    sha256 "614bb9d30094edd2f7704989c890178c19f8b6aab568b59cbe3711788699ba95" => :mojave
    sha256 "096629c7be18cd01c278f60c6a1ec0530c52c217637e32a6c7ff38405720336c" => :high_sierra
  end

  resource "bootstrap" do
    url "https://downloads.sourceforge.net/project/freepascal/Mac%20OS%20X/3.0.4/fpc-3.0.4a.intel-macosx.dmg"
    sha256 "56b870fbce8dc9b098ecff3c585f366ad3e156ca32a6bf3b20091accfb252616"
  end

  depends_on "subversion" => :build if MacOS.version >= :catalina

  # Help fpc find the startup files (crt1.o and friends) with 10.14 SDK
  patch :DATA

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

__END__
diff --git a/compiler/systems/t_bsd.pas b/compiler/systems/t_bsd.pas
index b35a78ae..61d0817d 100644
--- a/compiler/systems/t_bsd.pas
+++ b/compiler/systems/t_bsd.pas
@@ -465,7 +465,10 @@ begin
   if startupfile<>'' then
     begin
      if not librarysearchpath.FindFile(startupfile,false,result) then
-       result:='/usr/lib/'+startupfile;
+       if sysutils.fileexists('/usr/lib/'+startupfile) then
+         result:='/usr/lib/'+startupfile
+       else if sysutils.fileexists('/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib/') then
+         result:='/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib/'+startupfile;
     end;
   result:=maybequoted(result);
 end;
