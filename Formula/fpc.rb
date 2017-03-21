class Fpc < Formula
  desc "Free Pascal: multi-architecture Pascal compiler"
  homepage "http://www.freepascal.org/"
  url "https://downloads.sourceforge.net/project/freepascal/Source/3.0.2/fpc-3.0.2.source.tar.gz"
  sha256 "67fccddf5da992356f4e90d836444750ce9363608c7db8e38c077f710fcb6258"

  bottle do
    cellar :any_skip_relocation
    sha256 "79462df36eb732e04c7d5c1d1782ff24dc6ac533b6ec5629965b47fe603c8616" => :sierra
    sha256 "20886e1135ad520727087fb8ab9d3b2bf49b7ea275f8af725b9d3bf17bab4aba" => :el_capitan
    sha256 "946ccb4fb90ef1809111003f1b2da68dddd599f8c73c450e95aa3cd948e86c8e" => :yosemite
  end

  resource "bootstrap" do
    url "ftp://ftp.freepascal.org/pub/fpc/dist/3.0.0/bootstrap/x86_64-macosx-10.7-ppcx64.tar.bz2"
    sha256 "a67ef5def356d122a4692e21b209c328f6d46deef4539f4d4506c3dc1eecb4b0"
  end

  def install
    fpc_bootstrap = buildpath/"bootstrap"
    resource("bootstrap").stage { fpc_bootstrap.install Dir["*"] }

    fpc_compiler = fpc_bootstrap/"ppcx64"
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
