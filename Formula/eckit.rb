class Eckit < Formula
  desc "C++ toolkit that supports development of tools and applications at ECMWF"
  homepage "https://github.com/ecmwf/eckit"
  url "https://github.com/ecmwf/eckit/archive/refs/tags/1.23.1.tar.gz"
  sha256 "cd3c4b7a3a2de0f4a59f00f7bab3178dd59c0e27900d48eaeb357975e8ce2f15"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/ecmwf/eckit/tags"
    regex(/^v?(\d(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => :build

  resource "ecbuild" do
    url "https://github.com/ecmwf/ecbuild/archive/refs/tags/3.7.2.tar.gz"
    sha256 "7a2d192cef1e53dc5431a688b2e316251b017d25808190faed485903594a3fb9"
  end

  def install
    (buildpath/"ecbuild").install resource("ecbuild")
    mkdir "build" do
      system buildpath/"ecbuild/bin/ecbuild", "--prefix=#{buildpath}/install", "..", *std_cmake_args
      system "cmake", "--build", "."
      system "cmake", "--install", "."
    end

    shim_references = [
      lib/"pkgconfig/eckit_mpi.pc",
      lib/"pkgconfig/eckit_cmd.pc",
      lib/"pkgconfig/eckit_test_value_custom_params.pc",
      lib/"pkgconfig/eckit_option.pc",
      lib/"pkgconfig/eckit_maths.pc",
      lib/"pkgconfig/eckit_web.pc",
      lib/"pkgconfig/eckit_sql.pc",
      lib/"pkgconfig/eckit.pc",
      lib/"pkgconfig/eckit_linalg.pc",
      lib/"pkgconfig/eckit_geometry.pc",
      include/"eckit/eckit_ecbuild_config.h",
    ]
    inreplace shim_references, Superenv.shims_path/ENV.cxx, ENV.cxx
    inreplace shim_references, Superenv.shims_path/ENV.cc, ENV.cc
  end

  test do
    if OS.linux?
      system "test", "-f", "#{lib}/libeckit.so"
    else
      system "test", "-f", "#{lib}/libeckit.dylib"
    end

    system "#{bin}/eckit-version"
  end
end
