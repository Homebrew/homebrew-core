class Cereal < Formula
  desc "C++11 library for serialization"
  homepage "https://uscilab.github.io/cereal/"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/USCiLab/cereal.git", branch: "master"

  stable do
    url "https://github.com/USCiLab/cereal/archive/refs/tags/v1.3.2.tar.gz"
    sha256 "16a7ad9b31ba5880dac55d62b5d6f243c3ebc8d46a3514149e56b5e7ea81f85f"

    # clang 19+ build patch, upstream pr ref, https://github.com/USCiLab/cereal/pull/835
    patch do
      url "https://github.com/USCiLab/cereal/commit/409db5e910279224bd7e78f8188450c7e7d34d87.patch?full_index=1"
      sha256 "ad413ad34abb4ad515777013f1824f6f8eef879d3391f35cb0bf4b7e30937a7c"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dc981dc92c83e4642a9ae88b2f9c19df8eed192e09c458ff80d4ad7216c71f25"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DJUST_INSTALL_CEREAL=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <cereal/types/unordered_map.hpp>
      #include <cereal/types/memory.hpp>
      #include <cereal/archives/binary.hpp>
      #include <fstream>

      struct MyRecord
      {
        uint8_t x, y;
        float z;

        template <class Archive>
        void serialize( Archive & ar )
        {
          ar( x, y, z );
        }
      };

      struct SomeData
      {
        int32_t id;
        std::shared_ptr<std::unordered_map<uint32_t, MyRecord>> data;

        template <class Archive>
        void save( Archive & ar ) const
        {
          ar( data );
        }

        template <class Archive>
        void load( Archive & ar )
        {
          static int32_t idGen = 0;
          id = idGen++;
          ar( data );
        }
      };

      int main()
      {
        std::ofstream os("out.cereal", std::ios::binary);
        cereal::BinaryOutputArchive archive( os );

        SomeData myData;
        archive( myData );

        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-o", "test"
    system "./test"
    assert_path_exists testpath/"out.cereal"
  end
end
