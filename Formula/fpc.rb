class Fpc < Formula
  desc "Free Pascal: multi-architecture Pascal compiler"
  homepage "https://www.freepascal.org/"
  url "https://downloads.sourceforge.net/project/freepascal/Source/3.2.0/fpc-3.2.0.source.tar.gz"
  sha256 "d595b72de7ed9e53299694ee15534e5046a62efa57908314efa02d5cc3b1cf75"
  license "GPL-2.0-or-later"

  # fpc releases involve so many files that the tarball is pushed out of the
  # RSS feed and we can't rely on the SourceForge strategy.
  livecheck do
    url "https://sourceforge.net/projects/freepascal/files/Source/"
    strategy :page_match
    regex(%r{href=(?:["']|.*?Source/)?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "f9bdd01fdd59d08c5f4084fde70e4416f13e31625a4134ea7d55828d8bb476b2" => :big_sur
    sha256 "6f09e7b73774504d5a87681001fcb53632cbc98a143b94fd5cc91e90853a1f3e" => :arm64_big_sur
    sha256 "2a17877832cf7554835fd5c35d27931c4197604f9ea8161411bfa49746e8ad60" => :catalina
    sha256 "84a01f7ad8382fab6aa36bad5378009be66d1d0cd8870fe235b2f5d22102c4fd" => :mojave
    sha256 "96603ce0f998b1eb7c5b0e15b4ad49bbcca2b9943276ddf46d224f844f04582d" => :high_sierra
  end

  resource "bootstrap" do
    url "https://downloads.sourceforge.net/project/freepascal/Mac%20OS%20X/3.0.4/fpc-3.0.4a.intel-macosx.dmg"
    sha256 "56b870fbce8dc9b098ecff3c585f366ad3e156ca32a6bf3b20091accfb252616"
  end

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
