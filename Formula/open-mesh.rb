class OpenMesh < Formula
  desc "Generic data structure to represent and manipulate polygonal meshes"
  homepage "https://openmesh.org/"
  url "https://www.openmesh.org/media/Releases/5.1/OpenMesh-5.1.tar.gz"
  sha256 "643262dec62d1c2527950286739613a5b8d450943c601ecc42a817738556e6f7"
  head "https://www.graphics.rwth-aachen.de:9000/OpenMesh/OpenMesh.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a34226124549c2d56c74723a11585a2948edf2e6f60851ef63eab1c826647d7f" => :sierra
    sha256 "89cb1989a31311b1d2fb741dc35e06a6e9e077273cb63560f7bfcaa5b796ca27" => :el_capitan
    sha256 "fa31eb68403e75daa03eac85164864ba80bb3c76f59db97778777f78dfaa10a1" => :yosemite
  end

  depends_on "cmake" => :build

  stable do
    patch do
      # Fixes missing include files in OpenMesh/Tools/Smoother during install
      url "https://graphics.rwth-aachen.de:9000/OpenMesh/OpenMesh/commit/c5cfef87427a793268f9e012856872bbed958d92.diff"
      sha256 "5180b3ea8e92b88e9212a4fcfc214666d3b2ca2133a95c2f6b0a44855a298c79"
    end
  end

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_APPS=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
