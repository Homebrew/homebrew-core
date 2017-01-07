class Fpc < Formula
  desc "Free Pascal: multi-architecture Pascal compiler"
  homepage "http://www.freepascal.org/"
  url "https://downloads.sourceforge.net/project/freepascal/Source/3.0.0/fpc-3.0.0.source.tar.gz"
  sha256 "46354862cefab8011bcfe3bc2942c435f96a8958b245c42e10283ec3e44be2dd"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "35b53c70f590c62145692322625cfd3a3701efb579e6ccc6b64a6983560617d2" => :sierra
    sha256 "90bd14eab6b3f2acf161c6d80a4db97164ea42686a5d0cb8bf259c1ef3eeab27" => :el_capitan
    sha256 "5bb1a1b7dcc76bb2fd5457df3a811f2db4f0c536ce5d1210aec64f27fd02ce44" => :yosemite
  end

  resource "bootstrap" do
    url "https://downloads.sourceforge.net/project/freepascal/Bootstrap/2.6.4/universal-macosx-10.5-ppcuniversal.tar.bz2"
    sha256 "e7243e83e6a04de147ebab7530754ec92cd1fbabbc9b6b00a3f90a796312f3e9"
  end

  def install
    # The bootstrap binary does not recognize anything above 10.9
    # http://bugs.freepascal.org/view.php?id=30711
    # https://github.com/Homebrew/homebrew-core/issues/5732
    ENV["MACOSX_DEPLOYMENT_TARGET"] = "10.9"

    fpc_bootstrap = buildpath/"bootstrap"
    resource("bootstrap").stage { fpc_bootstrap.install Dir["*"] }

    fpc_compiler = fpc_bootstrap/"ppcuniversal"
    system "make", "build", "PP=#{fpc_compiler}"
    system "make", "install", "PP=#{fpc_compiler}", "PREFIX=#{prefix}"

    bin.install_symlink lib/"#{name}/#{version}/ppcx64"

    # Prevent non-executable audit warning
    rm_f Dir[bin/"*.rsj"]

    # Generate a default fpc.cfg to set up unit search paths
    system "#{bin}/fpcmkcfg", "-p", "-d", "basepath=#{lib}/fpc/#{version}", "-o", "#{prefix}/etc/fpc.cfg"
  end

  test do
    hello = <<-EOS.undent
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
