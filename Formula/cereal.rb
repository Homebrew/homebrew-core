class Cereal < Formula
  desc "C++11 library for serialization"
  homepage "https://uscilab.github.io/cereal/"
  url "https://github.com/USCiLab/cereal/archive/v1.2.2.tar.gz"
  sha256 "1921f26d2e1daf9132da3c432e2fd02093ecaedf846e65d7679ddf868c7289c4"
  head "https://github.com/USCiLab/cereal.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "6516d9b84ca4f0ca6140f1c3da3db1a4a8aad18c41e1b6b6412542d2f142955c" => :catalina
    sha256 "4edf85b9241c722b6938386d01edf3b6c8cc57060ffb38a9d5d70ef76273ab61" => :mojave
    sha256 "f7df56c0cb700d08a326948a052486c3899a0a38c0ede5af78b4d1d69a22fcf0" => :high_sierra
    sha256 "d0cf1bf42b9a95b861b96d456c528996e5918821b9f63e8d8dbf3bb44381378c" => :sierra
    sha256 "c4a716ed280100209d328085a3996c3116041bfaa78b9eeb837367de338efb95" => :el_capitan
    sha256 "c4a716ed280100209d328085a3996c3116041bfaa78b9eeb837367de338efb95" => :yosemite
  end

  depends_on "cmake" => :build

  # error: chosen constructor is explicit in copy-initialization
  # Reported 3 Sep 2016: https://github.com/USCiLab/cereal/issues/339
  depends_on :macos => :yosemite

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
