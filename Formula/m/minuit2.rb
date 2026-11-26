class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https://root.cern.ch/doc/master/Minuit2Page.html"
  url "https://root.cern.ch/download/root_v6.42.00.source.tar.gz"
  sha256 "9649ad16d5773bd05199eb5e3cca1580847a30c959e3e68c3717b471c154c4b2"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    manifest_sha256 "cea0a9b1114f4108722dcd130df67ed7ddd6c3d9597f823b79a2aa5c4d06882d"
    sha256 cellar: :any, arm64_golden_gate: "026f6f28c5b23b7cf19ca5abdf59f521ad07f72e64307d975091f5f8eb46e66e"
    sha256 cellar: :any, arm64_tahoe:       "c462b0cad3093fbde76e5d76981a4ee728f25a7057c4e443be8db0d5371ed5ae"
    sha256 cellar: :any, arm64_sequoia:     "1edc4222ed940e6f0d513c165c31a0d3ba2f8130b13c5af14d7844ff76bc1108"
    sha256 cellar: :any, arm64_linux:       "95e3f599c99ec4525d46953a50e5f1e256899cf71898c8c2a0abb139a7230ec0"
    sha256 cellar: :any, x86_64_linux:      "ccc7fde1d89f22c0574288cfe0d0ba25cbd5e8259de9d80afb5477b9b1232866"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", "math/minuit2", "-B", "build/shared", *std_cmake_args,
                    "-Dminuit2_standalone=ON", "-DCMAKE_CXX_FLAGS='-std=c++14'", "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", "math/minuit2", "-B", "build/static", *std_cmake_args,
                    "-Dminuit2_standalone=ON", "-DCMAKE_CXX_FLAGS='-std=c++14'", "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build/static"
    lib.install Dir["build/static/lib/libMinuit2*.a"]

    pkgshare.install "math/minuit2/test/MnTutorial"
  end

  test do
    cp Dir[pkgshare/"MnTutorial/{Quad1FMain.cxx,Quad1F.h}"], testpath
    system ENV.cxx, "-std=c++14", "Quad1FMain.cxx", "-o", "test", "-I#{include}/Minuit2", "-L#{lib}", "-lMinuit2"
    assert_match "par0: -8.26907e-11 -1 1", shell_output("./test")
  end
end
