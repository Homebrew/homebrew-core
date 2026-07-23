class Coal < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/coal-library/coal"
  url "https://github.com/coal-library/coal/releases/download/v3.0.4/coal-3.0.4.tar.gz"
  sha256 "0a9091aa281f51b9513f11aae39758a6188bca63010524f36b3bdc566381ca4a"
  license "BSD-2-Clause"
  compatibility_version 2
  head "https://github.com/coal-library/coal.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "04ecad151d0cf5e6a280518a02e6daed26cf697f4679db75313025bde1c4e6dd"
    sha256 cellar: :any, arm64_sequoia: "ca81636505c4c9585ee6977c845e31747eae438d59ce37fa591845494abf399f"
    sha256 cellar: :any, arm64_sonoma:  "e50f3aa66e6dfb347c6cc23aea31da2f309c870b7c3fb96b103e38730cfbb334"
    sha256 cellar: :any, sonoma:        "bd8d80fb623dcd40fa189bd062b50da6eeb8492018561625677878aee0603c8b"
    sha256 cellar: :any, arm64_linux:   "02080e3ad1897d5ec30aa1f039b24474f121476fc6ea26bee89b686099e87fe4"
    sha256 cellar: :any, x86_64_linux:  "5c4efbcb475d16a254f390f965307854aec92bb8f1c644f8486fb4d0398505d8"
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
  depends_on "python@3.14"

  def python3
    "python3.14"
  end

  def install
    ENV.prepend_path "PYTHONPATH", formula_opt_prefix("eigenpy")/Language::Python.site_packages(python3)
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
