class OpenMesh < Formula
  desc "Generic data structure to represent and manipulate polygonal meshes"
  homepage "https://openmesh.org/"
  url "https://www.openmesh.org/media/Releases/9.0/OpenMesh-9.0.tar.bz2"
  sha256 "69311a75b6060993b07fef005b328ea62178c13fbb0c44773874137231510218"
  license "BSD-3-Clause"
  head "https://www.graphics.rwth-aachen.de:9000/OpenMesh/OpenMesh.git", branch: "master"

  livecheck do
    url "https://www.openmesh.org/download/"
    regex(/href=.*?OpenMesh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "36d3182e03a2d69226203c13d3579fcc67faca7637fd8c437351e33012ed968b"
    sha256 cellar: :any,                 arm64_monterey: "04e362ff1d3d9dc04399cf018ca9d19330693094b2de00f66ce60dbb2afd9aed"
    sha256 cellar: :any,                 arm64_big_sur:  "ef9bdabb86ef70f589a16a33d0074bf4f22f1c5ae13bd66d78723e52df2ed921"
    sha256 cellar: :any,                 ventura:        "62f264ab93c9f611bacd9dc5007e635a49c056285953d9d94beb810b4472aa9a"
    sha256 cellar: :any,                 monterey:       "913221efd242346fa16b5e36313cbc614e9e397fd64a7dc21038012ef1bb4400"
    sha256 cellar: :any,                 big_sur:        "02040786c707f555cb3fe98ab34445f4034f4dcfc4ede94002207983be2e3767"
    sha256 cellar: :any,                 catalina:       "dafbe1a80d05a5e75477303dbc69d936a5bc366a8b20beaa52ecda864c796625"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce084fa027dba1d790612441f726eba166950f5c89b52beb8341c8d40bc932f7"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", "-DBUILD_APPS=OFF", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <OpenMesh/Core/IO/MeshIO.hh>
      #include <OpenMesh/Core/Mesh/PolyMesh_ArrayKernelT.hh>
      typedef OpenMesh::PolyMesh_ArrayKernelT<>  MyMesh;
      int main()
      {
          MyMesh mesh;
          MyMesh::VertexHandle vhandle[4];
          vhandle[0] = mesh.add_vertex(MyMesh::Point(-1, -1,  1));
          vhandle[1] = mesh.add_vertex(MyMesh::Point( 1, -1,  1));
          vhandle[2] = mesh.add_vertex(MyMesh::Point( 1,  1,  1));
          vhandle[3] = mesh.add_vertex(MyMesh::Point(-1,  1,  1));
          std::vector<MyMesh::VertexHandle>  face_vhandles;
          face_vhandles.clear();
          face_vhandles.push_back(vhandle[0]);
          face_vhandles.push_back(vhandle[1]);
          face_vhandles.push_back(vhandle[2]);
          face_vhandles.push_back(vhandle[3]);
          mesh.add_face(face_vhandles);
          try
          {
          if ( !OpenMesh::IO::write_mesh(mesh, "triangle.off") )
          {
              std::cerr << "Cannot write mesh to file 'triangle.off'" << std::endl;
              return 1;
          }
          }
          catch( std::exception& x )
          {
          std::cerr << x.what() << std::endl;
          return 1;
          }
          return 0;
      }

    EOS
    flags = %W[
      -I#{include}
      -L#{lib}
      -lOpenMeshCore
      -lOpenMeshTools
      --std=c++11
      -Wl,-rpath,#{lib}
    ]
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
