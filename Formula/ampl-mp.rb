class AmplMp < Formula
  desc "The AMPL modeling language solver library"
  homepage "http://www.ampl.com"
  url "https://github.com/ampl/mp/archive/3.1.0.tar.gz"
  sha256 "587c1a88f4c8f57bef95b58a8586956145417c8039f59b1758365ccc5a309ae9"
  revision 2

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
