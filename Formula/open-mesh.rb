class OpenMesh < Formula
  desc "Generic data structure to represent and manipulate polygonal meshes"
  homepage "https://openmesh.org/"
  url "https://www.openmesh.org/media/Releases/8.1/OpenMesh-8.1.tar.bz2"
  sha256 "9bc43a3201ba27ed63de66c4c09e23746272882c37a3451e71f0cf956f9be076"
  head "https://www.graphics.rwth-aachen.de:9000/OpenMesh/OpenMesh.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e066cb3914efa547fa06a4dfdbb4f5d4ecaf54c4eeaeecd4d41d4a0f3d16d23a"
    sha256 cellar: :any,                 arm64_big_sur:  "4602ad1fc42a6aa33f4198ad3a3ea165e65303936d16444a5002821d013463cb"
    sha256 cellar: :any,                 monterey:       "33029db8032f79b73a8e49a5f6cf79e95f9ea74615c09c60c49b443867000341"
    sha256 cellar: :any,                 big_sur:        "1162cfaad47a077402ef01854605a5fe5ab7e696ea56ab9352f753c25df231d6"
    sha256 cellar: :any,                 catalina:       "40eabd6160d88b74bb3298b42dfce249c327bee9a596b5911a4015462b457dfb"
    sha256 cellar: :any,                 mojave:         "3c523efbed147ef236ba22b7fdfc8fddae883b4ce7b9f03e970af199416adbe5"
    sha256 cellar: :any,                 high_sierra:    "a1b6514505ea011f01e8a61fd20dec9f31b900a42e8581e24a23beca738dc5f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0df53a37289dcca304749919744bfea1cb028291638b668dff65b804c9094dd1"
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
