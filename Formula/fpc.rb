class Fpc < Formula
  desc "Free Pascal: multi-architecture Pascal compiler"
  homepage "https://www.freepascal.org/"
  url "https://downloads.sourceforge.net/project/freepascal/Source/3.0.4/fpc-3.0.4.source.tar.gz"
  sha256 "69b3b7667b72b6759cf27226df5eb54112ce3515ff5efb79d95ac14bac742845"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "91c82c96317247dd7c5992a559b7ead81ad71e58c9be7331364bfd9a16558c32" => :mojave
    sha256 "adc48d394c224bd91e22e0963156c53323d6647b09a1ef6588a37a9444d29623" => :high_sierra
    sha256 "9117ae666c6b4f9b9fb63f9993b530c6910084090a1ae7668a06d7d1f9a1170c" => :sierra
  end

  resource "bootstrap" do
    url "https://downloads.sourceforge.net/project/freepascal/Bootstrap/3.0.0/x86_64-macosx-10.7-ppcx64.tar.bz2"
    sha256 "a67ef5def356d122a4692e21b209c328f6d46deef4539f4d4506c3dc1eecb4b0"
  end

  # Help fpc find the startup files (crt1.o and friends) with 10.14 SDK
  patch :DATA

  def install
    fpc_bootstrap = buildpath/"bootstrap"
    resource("bootstrap").stage { fpc_bootstrap.install Dir["*"] }
    fpc_compiler = fpc_bootstrap/"ppcx64"

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
@@ -310,7 +310,10 @@ begin
   if startupfile<>'' then
     begin
      if not librarysearchpath.FindFile(startupfile,false,result) then
-       result:='/usr/lib/'+startupfile
+       if sysutils.fileexists('/usr/lib/'+startupfile) then
+         result:='/usr/lib/'+startupfile
+       else if sysutils.fileexists('/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib/') then
+         result:='/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib/'+startupfile
     end
   else
     result:='';
