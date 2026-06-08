class OpenMesh < Formula
  desc "Generic data structure to represent and manipulate polygonal meshes"
  homepage "https://www.graphics.rwth-aachen.de/software/openmesh/"
  url "https://www.graphics.rwth-aachen.de/media/openmesh_static/Releases/11.0/OpenMesh-11.0.0.tar.bz2"
  sha256 "9d22e65bdd6a125ac2043350a019ec4346ea83922cafdf47e125a03c16f6fa07"
  license "BSD-3-Clause"
  head "https://gitlab.vci.rwth-aachen.de:9000/OpenMesh/OpenMesh.git", branch: "master"

  livecheck do
    url "https://www.graphics.rwth-aachen.de/software/openmesh/download/"
    regex(/href=.*?OpenMesh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "ae2697c40c059452bd27e81c7e43c0b3646ec6105b2f0e06cff61195402a0554"
    sha256 cellar: :any,                 arm64_sequoia:  "1b1e1f2436c2eef35ba7c5a9ad38c1a95a621faca514d4e82ef1e57d668d0494"
    sha256 cellar: :any,                 arm64_sonoma:   "34a5323c42111f78314efc77e19b9b5f595718155a22e480f75d0f559666c581"
    sha256 cellar: :any,                 arm64_ventura:  "c3766a3a3366ce1da776285750738811d5b38e752d1d487fcd4fca2f0249dc84"
    sha256 cellar: :any,                 arm64_monterey: "6ffaa80496d44e94d4ae6be0cd21e8ddfa23b5dadf9349284d65af6bebc2e45d"
    sha256 cellar: :any,                 sonoma:         "daad3b91c4ca6a713f80298891ca0287bba5118d9b2da41b209e626625b9cf86"
    sha256 cellar: :any,                 ventura:        "6c3376d904fd088a04933218be444ade532aa7dce3e956586445115f45efc776"
    sha256 cellar: :any,                 monterey:       "f7b5afee5b4b8f473457bcd29919e3dc4c1691ff168a271812a996323d5c4d15"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "04ad430f4a13a2bf8bf02e1a0a6f3cdaea50b910c7f25138be82d694784ea346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51111fc385d889eaee7e24daa21f468f830be446aa9fa27a6675220d65340862"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DBUILD_APPS=OFF
      -DCMAKE_CXX_STANDARD=14
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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

    CPP
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
