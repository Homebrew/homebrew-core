class AmplMp < Formula
  desc "The AMPL modeling language solver library"
  homepage "https://www.ampl.com/"
  url "https://github.com/ampl/mp/archive/3.1.0.tar.gz"
  sha256 "587c1a88f4c8f57bef95b58a8586956145417c8039f59b1758365ccc5a309ae9"
  revision 2

  bottle do
    cellar :any
    sha256 "db013b18d1c1ac615514e2ba8f760cc8b91120218b205d843d536beb3888237e" => :high_sierra
    sha256 "46d1cf71028cfaa76c3dc7fbc869dfdac4704f97c2963142df41afabe3bbc6f0" => :sierra
    sha256 "87744fa4f67c6f1d35ed70f17f04d96e19b6ed3312bcea224677d89a6d1c89f4" => :el_capitan
    sha256 "f9fd64bafa20eebd39425bf8331e0ca1962d47b1deeed589c347b75ced5e193d" => :yosemite
  end

  depends_on "cmake" => :build

  resource "miniampl" do
    url "https://github.com/dpo/miniampl/archive/v1.0.tar.gz"
    sha256 "b836dbf1208426f4bd93d6d79d632c6f5619054279ac33453825e036a915c675"
  end

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_SHARED_LIBS=True"
    system "make", "all"
    MachO::Tools.change_install_name("bin/libasl.dylib", "@rpath/libmp.3.dylib",
                                     "#{opt_lib}/libmp.dylib")
    system "make", "install"

    # Shared modules are installed in bin
    mkdir_p libexec/"bin"
    mv Dir[bin/"*.dll"], libexec/"bin"

    # Install missing header files, remove in > 3.1.0
    # https://github.com/ampl/mp/issues/110
    %w[errchk.h jac2dim.h obj_adj.h].each { |h| cp "src/asl/solvers/#{h}", include/"asl" }

    resource("miniampl").stage do
      (pkgshare/"example").install "src/miniampl.c", Dir["examples/wb.*"]
    end
  end

  test do
    system ENV.cc, pkgshare/"example/miniampl.c", "-I#{include}/asl", "-L#{lib}", "-lasl", "-lmp"
    cp Dir[pkgshare/"example/wb.*"], testpath
    output = shell_output("./a.out wb showname=1 showgrad=1")
    assert_match "Objective name: objective", output
  end
end
