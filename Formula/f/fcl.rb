class Fcl < Formula
  desc "Flexible Collision Library"
  homepage "https://flexible-collision-library.github.io/"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/flexible-collision-library/fcl.git", branch: "master"

  stable do
    url "https://github.com/flexible-collision-library/fcl/archive/refs/tags/0.7.0.tar.gz"
    sha256 "90409e940b24045987506a6b239424a4222e2daf648c86dd146cbcb692ebdcbc"

    # Backport C++ standard changes
    patch do
      url "https://github.com/flexible-collision-library/fcl/commit/1257b4183e0ae4890294b0edea780605c2533cfd.patch?full_index=1"
      sha256 "d3bb6bc82e926d4a89c19064f79b11506fa9899d52c46a482e3f9b41785b1291"
    end

    # Backport commits to apply subsequent patch
    patch do
      url "https://github.com/flexible-collision-library/fcl/commit/beffa1bb54da6686e8167843e051a3f9a2bad6f7.patch?full_index=1"
      sha256 "ab2058f7316e8ad6e9caa253e94c6f8dcad633ae02473d6353b9003552909525"
    end
    patch do
      url "https://github.com/flexible-collision-library/fcl/commit/3c2b993a0b1a10f888a53cce4f3c73035ab862c3.patch?full_index=1"
      sha256 "a483773630e9f28c59ace7edacb0a782c9b6a1830514b92e1465ce4828e1111d"
    end

    # Apply open PR to add cassert includes needed for eigen 5.0.0
    # PR ref: https://github.com/flexible-collision-library/fcl/pull/649
    patch do
      url "https://github.com/flexible-collision-library/fcl/commit/75ad2bc55acefb6c5638ed2730827530b4b7a176.patch?full_index=1"
      sha256 "6265c1178fe237313e107ae19386d7fc5d69638213d705290ddb61aea0b0fda2"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "520b5eb150c605c3d52439c344b97fc921978a7b766141f0deeb000d52a2be6c"
    sha256 cellar: :any,                 arm64_sequoia: "c3d2ac35822520051226489edef7331201d92857144d64a6fbc16339570bfbd5"
    sha256 cellar: :any,                 arm64_sonoma:  "84514294768694993849b6182e1c24956c437a05d1b3060033e5fb63590a81b9"
    sha256 cellar: :any,                 sonoma:        "c940f7e641313fc86f737a53cdee88816a34e0d89b67f626df78144c9d932147"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a6759eb4c1576b674bdf4528dc205df0e1ded7d98701282abc1b5868084767b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5213117e4717273be6ea9baf0bccda5ad8ec98a258be6e125b41d151b0cc5e32"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "eigen"
  depends_on "libccd"
  depends_on "octomap"

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
                    "-I#{Formula["eigen"].include}/eigen3",
                    "-L#{lib}", "-lfcl", "-o", "test"
    system "./test"
  end
end
