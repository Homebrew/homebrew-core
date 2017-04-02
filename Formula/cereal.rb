class Cereal < Formula
  desc "C++11 library for serialization"
  homepage "https://uscilab.github.io/cereal/"
  url "https://github.com/USCiLab/cereal/archive/v1.2.2.tar.gz"
  sha256 "1921f26d2e1daf9132da3c432e2fd02093ecaedf846e65d7679ddf868c7289c4"
  head "https://github.com/USCiLab/cereal.git", :branch => "develop"

  bottle :unneeded

  option "with-test", "Build and run the test suite"

  deprecated_option "with-tests" => "with-test"

  if build.with? "test"
    depends_on "cmake" => :build
    depends_on "boost" => :build
  end

  # error: chosen constructor is explicit in copy-initialization
  # Reported 3 Sep 2016: https://github.com/USCiLab/cereal/issues/339
  depends_on :macos => :yosemite

  needs :cxx11

  def install
    if build.with? "test"
      ENV.cxx11
      mkdir "build" do
        system "cmake", "..", *std_cmake_args
        system "make"
        system "make", "test"
      end
    end
    include.install "include/cereal"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
