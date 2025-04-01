class Coal < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/coal-library/coal"
  url "https://github.com/coal-library/coal/releases/download/v3.0.1/coal-3.0.1.tar.gz"
  sha256 "b9609301baefbbf45b4e0f80865abc2b2dcbb69c323a55b0cd95f141959c478c"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/coal-library/coal.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4b84ecd016c5f9421cebef052a4c5872dd81c5043857a257ebf534e83de0a40b"
    sha256 cellar: :any,                 arm64_sonoma:  "4b8864e60a709bcd4a09386230aa3f511308a402d2d66b0294b8bbc18f708704"
    sha256 cellar: :any,                 arm64_ventura: "4ddc8df90f72a39d67821b7c37e1d44c086b154c582ea11fdaac2571c6e37fc3"
    sha256 cellar: :any,                 sonoma:        "366f4884e4de18a9efe693880513c00b36be1346dfd4f08561035c31d6c46ef6"
    sha256 cellar: :any,                 ventura:       "847cece9b925893a6d142ee8c4f463475c3d967df46a2744066d536e86f21082"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14f1d055a67a32420a3b87f31ff364f0e7926440d8bedf4979c31aecf6ae303d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14a7ed5e9395d617dc0503196509ab33ac7748d77f53764749c14a283c4ae463"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "assimp"
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "eigenpy"
  depends_on "octomap"
  depends_on "python@3.13"

  def python3
    "python3.13"
  end

  def install
    ENV.prepend_path "PYTHONPATH", Formula["eigenpy"].opt_prefix/Language::Python.site_packages(python3)
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share/"eigen3/cmake"

    # enable backward compatibility with hpp-fcl
    args = %W[
      -DPYTHON_EXECUTABLE=#{which(python3)}
      -DCOAL_BACKWARD_COMPATIBILITY_WITH_HPP_FCL=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    %w[hppfcl coal].each do |module_name|
      system python3, "-c", <<~PYTHON
        exec("""
        import #{module_name}
        radius = 0.5
        sphere = #{module_name}.Sphere(0.5)
        assert sphere.radius == radius
        """)
      PYTHON
    end
  end
end
