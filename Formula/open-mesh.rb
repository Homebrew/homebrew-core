class OpenMesh < Formula
  desc "Generic data structure to represent and manipulate polygonal meshes"
  homepage "https://openmesh.org/"
  url "https://www.openmesh.org/media/Releases/6.2/OpenMesh-6.2.tar.gz"
  sha256 "570b5b2d3b949050d9628367268c495e87b3dc59f18a07c8037449356fe40374"
  head "http://openmesh.org/svnrepo/OpenMesh/trunk/", :using => :svn

  bottle do
    cellar :any
    sha256 "696e707dbbc25c6b2b6504eb78336a8833f9d690bbb07f226d9529258fc984f2" => :sierra
    sha256 "80c3297bf3f7ab9c4b519dd9ae622ea5c87fb5afdebaabeb4b4c8d3149067016" => :el_capitan
    sha256 "e73e25f5adbb12bd20bf822e472a2a883f6d969c1cb340d76feb1a83fc4c02cf" => :yosemite
    sha256 "f55c01c2dbde31f9307530349141b33860f733bbe2836fc88d79536bcd3945d4" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "qt" => :optional

  option "without-python", "Build without python 2 support"
  depends_on "boost-python"

  def install
    mkdir "build" do
      args = std_cmake_args

      if build.with? "qt"
        args << "-DBUILD_APPS=ON"
      else
        args << "-DBUILD_APPS=OFF"
      end

      if build.without? "python"
        args << "-DOPENMESH_BUILD_PYTHON_BINDINGS=OFF"
      else
        args << "-DOPENMESH_BUILD_PYTHON_BINDINGS=ON"
      end

      inreplace "#{buildpath}/src/Python/CMakeLists.txt", "${ACG_PROJECT_LIBDIR}/python", "${ACG_PROJECT_LIBDIR}/python2.7/site-packages"

      system "cmake", "..", *args
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
    system "python -c 'import openmesh;'"
  end
end
