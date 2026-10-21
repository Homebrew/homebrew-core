class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v4.1.0/pinocchio-4.1.0.tar.gz"
  sha256 "b2ac9575bd4f38e0584e0d61586a95de1aeaa17c6877e31e99f1d4b913d602d8"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3c3b07ade72bb106ef8fa18fc53190d984e50207a6c6c265cf01a524560886bf"
    sha256 cellar: :any, arm64_tahoe:       "b5c1db10753e1401027b9849182394d75197deacef93e317c664c7c21b3319d1"
    sha256 cellar: :any, arm64_sequoia:     "3e0d8143eb76e76df1ede70ba914709e65587cfc01210d8986acabdeef778bf4"
    sha256 cellar: :any, arm64_linux:       "859a946f092bf270957f85649c404a2bfbece0593edcd39a9f9f57dfb8d569d3"
    sha256 cellar: :any, x86_64_linux:      "0e28e50296eb9d4ec953bb9334b850cb11cc6a5d6b0b42a6efd74f792347a946"
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
