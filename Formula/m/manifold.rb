class Manifold < Formula
  desc "Geometry library for topological robustness"
  homepage "https://github.com/elalish/manifold"
  url "https://github.com/elalish/manifold/releases/download/v3.4.0/manifold-3.4.0.tar.gz"
  sha256 "03fb429c2080363cadc6e9a34ecd6ba7948c74d99baffb3df381546effaa6907"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ff5b52cf774a2b72df13344d7def1b31bfaab648e03bbb72b89bbee195672f10"
    sha256 cellar: :any,                 arm64_sequoia: "68b8fc149de8d3c70ca69db3adcc2e1712c3c78fbc11d9abb77797e54801ae28"
    sha256 cellar: :any,                 arm64_sonoma:  "b20d317e18de7a0a966b280afb188f7f755f40733333cc88994f66150ae1fdb2"
    sha256 cellar: :any,                 sonoma:        "6c32634e31bb38a8762f582ba9ff248d40b9a2bb8b35203f0570fadf1477f9b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b095363687ac275a354fa73047d606384b136873ba81136764ec99fab9dc1a62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b60c665359a57701df2f9333280caed43643557245792962dfd77da577c0b19"
  end

  depends_on "cmake" => :build
  depends_on "clipper2"
  depends_on "tbb"

  def install
    args = %w[
      -DMANIFOLD_DOWNLOADS=OFF
      -DMANIFOLD_PAR=ON
      -DMANIFOLD_TEST=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "extras/large_scene_test.cpp"
  end

  test do
    system ENV.cxx, pkgshare/"large_scene_test.cpp",
                    "-std=c++17", "-I#{include}", "-L#{lib}", "-lmanifold",
                    "-o", "test"
    assert_match "nTri = 91814", shell_output("./test")
  end
end
