class OpenMesh < Formula
  desc "Generic data structure to represent and manipulate polygonal meshes"
  homepage "https://www.graphics.rwth-aachen.de/software/openmesh/"
  url "https://www.graphics.rwth-aachen.de/media/openmesh_static/Releases/10.0/OpenMesh-10.0.0.tar.bz2"
  sha256 "af22520a474bb6a3b355eb0867449c6b995126f97632d1ee5ff9c7ebd322fedb"
  license "BSD-3-Clause"
  head "https://gitlab.vci.rwth-aachen.de:9000/OpenMesh/OpenMesh.git", branch: "master"

  livecheck do
    url "https://www.graphics.rwth-aachen.de/software/openmesh/download/"
    regex(/href=.*?OpenMesh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d2643de5a8d90f95c0a4644ccd3972762dbfd991b9c06674e37285596616da77"
    sha256 cellar: :any,                 arm64_ventura:  "3b8778dd880d78eeb903270a3e33b6750dade2e15489ea1d02003457c23a54ee"
    sha256 cellar: :any,                 arm64_monterey: "5aba286438423ebc8e6e0efcd3a0c6470163117cc5ed4e8dddcd265140a3c690"
    sha256 cellar: :any,                 sonoma:         "0f7f833c8180a1cb9c60c06d1e999310dc19838996171e5ac62dc076a665ad1a"
    sha256 cellar: :any,                 ventura:        "8003b56794b799917cb0e7be9c166b8127168a174cee2e3fb823df059fc9347e"
    sha256 cellar: :any,                 monterey:       "84afd6d942d42c585fd29a757509b23d171430528ebfa7c67b3617243d2293a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e07eef120683c84a271e1e106c8c9f2db7fc4139747c83bf300edb0e39101f9"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_APPS=OFF",
                    "-DCMAKE_CXX_STANDARD=14",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
      -std=c++14
      -Wl,-rpath,#{lib}
    ]
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
