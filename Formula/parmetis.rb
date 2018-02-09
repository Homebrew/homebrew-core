class Parmetis < Formula
  desc "MPI library for graph/mesh partitioning and fill-reducing orderings"
  homepage "http://glaros.dtc.umn.edu/gkhome/metis/parmetis/overview"
  url "http://glaros.dtc.umn.edu/gkhome/fetch/sw/parmetis/parmetis-4.0.3.tar.gz"
  sha256 "f2d9a231b7cf97f1fee6e8c9663113ebf6c240d407d3c118c55b3633d6be6e5f"

  # Prefer our metis over the bundled one
  depends_on "metis"

  depends_on "cmake" => :build
  depends_on "open-mpi"

  # Do not build the METIS 5.* that ships with ParMETIS.
  # Ideally ParMETIS would provide a cmake flag for this
  patch :DATA

  # Bug fixes from PETSc developers. Mirrored because the SHA-256s get
  # invalidated every time Bitbucket updates the Git version they use.
  patch do
    # From: https://bitbucket.org/petsc/pkg-parmetis/commits/82409d68aa1d6cbc70740d0f35024aae17f7d5cb/raw/
    url "https://raw.githubusercontent.com/Homebrew/patches/f104fbb1e09402798cbbc06d2f695d85398c0c89/parmetis/commit-82409d68.patch"
    sha256 "0349f5bc19a2ba9fe9e1b9d385072dabe59262522bd7cf66f26c6bc31bbb1b86"
  end

  patch do
    # From: https://bitbucket.org/petsc/pkg-parmetis/commits/1c1a9fd0f408dc4d42c57f5c3ee6ace411eb222b/raw/
    url "https://raw.githubusercontent.com/Homebrew/patches/f104fbb1e09402798cbbc06d2f695d85398c0c89/parmetis/commit-1c1a9fd0.patch"
    sha256 "baec5e1fa6bb4f6c59e3ede564485e0ad743f58c9875fd65cb715b5c14a491b5"
  end

  def install
    ENV["LDFLAGS"] = "-L#{Formula["metis"].opt_lib} -lmetis -lm"

    system "make", "config", "prefix=#{prefix}", "shared=1"
    system "make", "install"
    pkgshare.install "Graphs" # Sample data for test
  end

  test do
    system "mpirun", "#{bin}/ptest", "#{pkgshare}/Graphs/rotor.graph"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index ca945dd..1bf94e9 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -33,7 +33,7 @@ include_directories(${GKLIB_PATH})
 include_directories(${METIS_PATH}/include)

 # List of directories that cmake will look for CMakeLists.txt
-add_subdirectory(${METIS_PATH}/libmetis ${CMAKE_BINARY_DIR}/libmetis)
+#add_subdirectory(${METIS_PATH}/libmetis ${CMAKE_BINARY_DIR}/libmetis)
 add_subdirectory(include)
 add_subdirectory(libparmetis)
 add_subdirectory(programs)

diff --git a/libparmetis/CMakeLists.txt b/libparmetis/CMakeLists.txt
index 9cfc8a7..dfc0125 100644
--- a/libparmetis/CMakeLists.txt
+++ b/libparmetis/CMakeLists.txt
@@ -5,7 +5,7 @@ file(GLOB parmetis_sources *.c)
 # Create libparmetis
 add_library(parmetis ${ParMETIS_LIBRARY_TYPE} ${parmetis_sources})
 # Link with metis and MPI libraries.
-target_link_libraries(parmetis metis ${MPI_LIBRARIES})
+target_link_libraries(parmetis metis ${MPI_LIBRARIES} "-lm")
 set_target_properties(parmetis PROPERTIES LINK_FLAGS "${MPI_LINK_FLAGS}")

 install(TARGETS parmetis
