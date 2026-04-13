class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v4.0.0/pinocchio-4.0.0.tar.gz"
  sha256 "0cfa23e2874eb9978dd7d952f3d8df855adb14e166b1a31860ac5c28c6348fb4"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "e4bbe183743cad8e1c68f34c8f858e2f278d304958e365f45b62cf077298cedf"
    sha256                               arm64_sequoia: "fa40ab2ba8843d4eda72671a0f9dba7ac21e6b2a257573089fcba878c321612f"
    sha256                               arm64_sonoma:  "ae8057a7e9d9382e1ef4df2d5733c29dbe18e6e90cacad424997413387080971"
    sha256 cellar: :any,                 sonoma:        "4662246589fc14509c0535961667e231d67eeea55eb13f51c6612ad5a71b5fe2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14fcdbabfc8c04c4eb2a3de820966cf03721169d3725ba11134065493d31a3bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fe29e9a56fc9552757c2758dc33b3ae4b72460a509b0b3ab4a849259df6539b"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build

  depends_on "boost"
  depends_on "boost-python3"
  depends_on "coal"
  depends_on "console_bridge"
  depends_on "eigen"
  depends_on "eigenpy"
  depends_on "python@3.14"
  depends_on "urdfdom"

  on_macos do
    depends_on "octomap"
  end

  # Add a no-op `ComputeBlockDiagonalPatternImpl` specialization for
  # `boost::blank`-derived sentinels (e.g. `BlankConstraintModel`).
  patch :DATA

  def python3
    "python3.14"
  end

  def install
    if build.head?
      system "git", "submodule", "update", "--init"
      system "git", "pull", "--unshallow", "--tags"
    end

    args = %W[
      -DPYTHON_EXECUTABLE=#{which(python3)}
      -DBUILD_UNIT_TESTS=OFF
      -DBUILD_WITH_COLLISION_SUPPORT=ON
    ]
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-rpath,#{rpath}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", <<~PYTHON
      import pinocchio
      model = pinocchio.Model()
      data = model.createData()
      assert model.nv == 0 and model.nq == 0
    PYTHON
  end
end

__END__
--- a/include/pinocchio/src/constraints/utils.hxx
+++ b/include/pinocchio/src/constraints/utils.hxx
@@ -952,6 +952,16 @@
       }
     };

+    template<typename ConstraintModel>
+    struct ComputeBlockDiagonalPatternImpl<
+      ConstraintModel,
+      std::enable_if_t<std::is_base_of_v<boost::blank, ConstraintModel>>>
+    {
+      template<typename BlockInfoVector, BlockDiagonalDispatcherType op>
+      static void run(
+        const ConstraintModel &, BlockInfoVector &, BlockDiagonalDispatcherTag<op>) {}
+    };
+
     // Specialization of compute block_infos for FrameAnchor.
     template<typename Scalar, int Options>
     struct ComputeBlockDiagonalPatternImpl<FrameAnchorConstraintModelTpl<Scalar, Options>>
