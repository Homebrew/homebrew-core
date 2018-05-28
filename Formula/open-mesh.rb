class OpenMesh < Formula
  desc "Generic data structure to represent and manipulate polygonal meshes"
  homepage "https://openmesh.org/"
  url "https://www.openmesh.org/media/Releases/7.0/OpenMesh-7.0.tar.bz2"
  sha256 "e8e9414f7b0beba8603945d7794ee38712f3594a8b539a4acfaaad398d543e85"
  head "https://www.graphics.rwth-aachen.de:9000/OpenMesh/OpenMesh.git"

  bottle do
    cellar :any
    sha256 "1ee3e6c151787c3ad3a542b1e1cac0c1dddce2846fbf2ff334745339e764bb78" => :high_sierra
    sha256 "a933918f4f0ec229d3c747564fa85563d252932ddcc66d3d08571492abe6bf6b" => :sierra
    sha256 "e23c60eff184291c797acda43f99a8b1f363c3e8a853ba1bb6c70c7381507fb1" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", "-DBUILD_APPS=OFF", *std_cmake_args
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
    ]
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
