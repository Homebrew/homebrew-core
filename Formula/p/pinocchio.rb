class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v4.1.0/pinocchio-4.1.0.tar.gz"
  sha256 "b2ac9575bd4f38e0584e0d61586a95de1aeaa17c6877e31e99f1d4b913d602d8"
  license "BSD-2-Clause"
  revision 3
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "159fe053f11b1a6505a5dd2862c1cd22e2985851bdf40c6700dc5fdd2bc288c5"
    sha256 cellar: :any, arm64_golden_gate: "6c68bc17289d1d659da6d37ece49b3f43c65db9d545836b623a6f9dbd7badfbb"
    sha256 cellar: :any, arm64_tahoe:       "0d3c472b96d608d83933d21220b01988fdfd52fe63210f024db73eadd1c4583a"
    sha256 cellar: :any, arm64_sequoia:     "fec6a5bea47e501623550afb723672f8836c30f351ac58e0b3665bd10d46a342"
    sha256 cellar: :any, arm64_linux:       "cbcba26b9fb1372e35d8455ea8c2a4ee496066cfd3eae3e43db6bb2059ac9000"
    sha256 cellar: :any, x86_64_linux:      "7b7fa42170cc63d1201971e5a5e611f6088d669cd3d4708421e2582bef14adab"
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
  depends_on "python@3.15"
  depends_on "urdfdom"

  on_macos do
    depends_on "octomap"
  end

  # Allow building with Boost 1.92.0. Can be dropped once upstream replaces Boost.Python with nanobind
  # Ref: https://github.com/stack-of-tasks/pinocchio/pull/2873
  patch :DATA

  def install
    if build.head?
      system "git", "submodule", "update", "--init"
      system "git", "pull", "--unshallow", "--tags"
    end

    args = %W[
      -DPYTHON_EXECUTABLE=#{python3}
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
diff --git a/include/pinocchio/src/parsers/graph/geometries.hxx b/include/pinocchio/src/parsers/graph/geometries.hxx
index ade2ba270..1577f9143 100644
--- a/include/pinocchio/src/parsers/graph/geometries.hxx
+++ b/include/pinocchio/src/parsers/graph/geometries.hxx
@@ -32,6 +32,11 @@ namespace pinocchio
       : path(name_path)
       {
       }
+
+      bool operator==(const Mesh & other) const
+      {
+        return path == other.path;
+      }
     };
 
     struct Box
@@ -43,6 +48,11 @@ namespace pinocchio
       : size(size)
       {
       }
+
+      bool operator==(const Box & other) const
+      {
+        return size == other.size;
+      }
     };
 
     struct Cylinder
@@ -54,6 +64,11 @@ namespace pinocchio
       : size(size)
       {
       }
+
+      bool operator==(const Cylinder & other) const
+      {
+        return size == other.size;
+      }
     };
 
     struct Capsule
@@ -65,6 +80,11 @@ namespace pinocchio
       : size(size)
       {
       }
+
+      bool operator==(const Capsule & other) const
+      {
+        return size == other.size;
+      }
     };
 
     struct Sphere
@@ -76,6 +96,11 @@ namespace pinocchio
       : radius(r)
       {
       }
+
+      bool operator==(const Sphere & other) const
+      {
+        return radius == other.radius;
+      }
     };
 
     typedef boost::variant<Mesh, Box, Cylinder, Capsule, Sphere> GeomVariant;
@@ -111,6 +136,13 @@ namespace pinocchio
       , geometry(geom)
       {
       }
+
+      bool operator==(const Geometry & other) const
+      {
+        return name == other.name && type == other.type && scale == other.scale
+               && color == other.color && placement == other.placement
+               && geometry == other.geometry;
+      }
     };
   } // namespace graph
 } // namespace pinocchio
