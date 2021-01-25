class Cereal < Formula
  desc "C++11 library for serialization"
  homepage "https://uscilab.github.io/cereal/"
  url "https://github.com/USCiLab/cereal/archive/v1.3.0.tar.gz"
  sha256 "329ea3e3130b026c03a4acc50e168e7daff4e6e661bc6a7dfec0d77b570851d5"
  license "BSD-3-Clause"
  head "https://github.com/USCiLab/cereal.git", branch: "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "a91e1e24d8bad693211e5854f9270bc54167c261c8b7d5434d5a8983af06a792" => :big_sur
    sha256 "62497644813556eff7bc7da0aad2d13e8d21ef98d21ee12b090bcfbcd909e0e8" => :arm64_big_sur
    sha256 "a8320898b751c2df4777d1fd77f9982a812972b46630fa060b21e412c545a14d" => :catalina
    sha256 "a8320898b751c2df4777d1fd77f9982a812972b46630fa060b21e412c545a14d" => :mojave
    sha256 "a8320898b751c2df4777d1fd77f9982a812972b46630fa060b21e412c545a14d" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DJUST_INSTALL_CEREAL=ON", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
    EOS
    system ENV.cc, "-std=c++11", "-stdlib=libc++", "-lc++", "-o", "test", "test.cpp"
    system "./test"
  end
end
