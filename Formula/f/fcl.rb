class Fcl < Formula
  desc "Flexible Collision Library"
  homepage "https://flexible-collision-library.github.io/"
  license "BSD-3-Clause"
  revision 3
  compatibility_version 1
  head "https://github.com/flexible-collision-library/fcl.git", branch: "master"

  stable do
    url "https://github.com/flexible-collision-library/fcl/archive/refs/tags/0.7.0.tar.gz"
    sha256 "90409e940b24045987506a6b239424a4222e2daf648c86dd146cbcb692ebdcbc"

    # Backport C++ standard changes
    patch do
      url "https://github.com/flexible-collision-library/fcl/commit/1257b4183e0ae4890294b0edea780605c2533cfd.patch?full_index=1"
      sha256 "d3bb6bc82e926d4a89c19064f79b11506fa9899d52c46a482e3f9b41785b1291"
      type :backport
      resolves "https://github.com/flexible-collision-library/fcl/pull/645"
    end

    # Backport commits to apply subsequent patch
    patch do
      url "https://github.com/flexible-collision-library/fcl/commit/beffa1bb54da6686e8167843e051a3f9a2bad6f7.patch?full_index=1"
      sha256 "ab2058f7316e8ad6e9caa253e94c6f8dcad633ae02473d6353b9003552909525"
      type :backport
      resolves "https://github.com/flexible-collision-library/fcl/pull/594"
    end
    patch do
      url "https://github.com/flexible-collision-library/fcl/commit/3c2b993a0b1a10f888a53cce4f3c73035ab862c3.patch?full_index=1"
      sha256 "a483773630e9f28c59ace7edacb0a782c9b6a1830514b92e1465ce4828e1111d"
      type :backport
      resolves "https://github.com/flexible-collision-library/fcl/pull/634"
    end

    # Apply open PR to add cassert includes needed for eigen 5.0.0
    patch do
      url "https://github.com/flexible-collision-library/fcl/commit/75ad2bc55acefb6c5638ed2730827530b4b7a176.patch?full_index=1"
      sha256 "6265c1178fe237313e107ae19386d7fc5d69638213d705290ddb61aea0b0fda2"
      type :unofficial
      resolves "https://github.com/flexible-collision-library/fcl/pull/649"
    end

    # Link the octomap::octomap target exported by OctoMap 2.0
    patch do
      url "https://github.com/flexible-collision-library/fcl/commit/dba11957540eda3656429cdfd4b8ba03557b60d2.patch?full_index=1"
      sha256 "d727a5a703a1a0f9304d9987b79734d2655193125fce5bc6dc14b6f22435dcc2"
      type :unofficial
      resolves "https://github.com/flexible-collision-library/fcl/pull/672"
    end
  end

  bottle do
    manifest_sha256 "bae14e4a1a4540894c71732f3054ae5c610843e542e9df787dbdc66473c0f21c"
    sha256 cellar: :any, arm64_golden_gate: "faa05739d19f3031309bc5dac7f2af8da0402fca8e53bcf5e0bb6b07eb4dba6c"
    sha256 cellar: :any, arm64_tahoe:       "b608fba1ca24b458ef1e39d05fbb7c178dd315e9f7f098d159412d133f274d2d"
    sha256 cellar: :any, arm64_sequoia:     "dbc8a7a22e55cab98662a731e113e547dd3beb533371c2979ee166e161ade375"
    sha256 cellar: :any, arm64_linux:       "a9dbe25f0e5bceb190dec90424d48f32b34bc9d52cdab5d35964f6c8e66e068a"
    sha256 cellar: :any, x86_64_linux:      "5dd32290d648be8f2fd5cd4c58eafa337acd054c4740c3080f1fa403ac5726f4"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "eigen"
  depends_on "libccd"
  depends_on "octomap"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=14", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <fcl/geometry/shape/box.h>
      #include <cassert>

      int main() {
        assert(fcl::Boxd(1, 1, 1).computeVolume() == 1);
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++14", "-I#{include}",
                    "-I#{formula_opt_include("eigen")}/eigen3",
                    "-L#{lib}", "-lfcl", "-o", "test"
    system "./test"
  end
end
