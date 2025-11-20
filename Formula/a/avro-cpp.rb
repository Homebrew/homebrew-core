class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.12.1/cpp/avro-cpp-1.12.1.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.12.1/cpp/avro-cpp-1.12.1.tar.gz"
  sha256 "18a0d155905a4dab0c2bfd66c742358a7d969bcff58cf6f655bcf602879f4fe7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b89b52514a01938e58227cea3df043f72c11d92517e50e612b7b21dc21a2896e"
    sha256 cellar: :any,                 arm64_sequoia: "87b4bc2edf4027fb23b6377efc812502ee28d5824fcaa985b505cdb74b7affaa"
    sha256 cellar: :any,                 arm64_sonoma:  "3b5fd6eab8771d335bdcd737c3a36829517744a98d628ba4478ae3832f719d8c"
    sha256 cellar: :any,                 sonoma:        "fc835f42954873b7b49d89070ca917f1b441e46fa3ce2ba74a66951aac80f2ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07d6dfb9075c7ebfe7b280a386f7ae12e05ad6359426f170de52e2333f1280ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abb4bdc11f71daeb6474d1f46bbac5dd9d8d80bd916e1386aeb457042c37964d"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => [:build, :test] # needed for headers
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "zstd"

  uses_from_macos "zlib"

  # Add missing cmake file from git
  resource "avro-cpp-config.cmake.in" do
    url "https://github.com/apache/avro/raw/refs/tags/release-1.12.1/lang/c++/cmake/avro-cpp-config.cmake.in"
    sha256 "2f100bed5a5ec300bc16e618ef17c64056c165a3dba8dde590a3ef65352440fa"
  end

  def install
    (buildpath/"cmake").install resource("avro-cpp-config.cmake.in")

    # Boost 1.89+ no longer requires the 'system' component
    boost_replacements = /Boost\s1.70\sREQUIRED\s(CONFIG\s)?COMPONENTS\s?system/
    inreplace "CMakeLists.txt" do |s|
      s.gsub! boost_replacements, "Boost REQUIRED"
      s.gsub! "$<INSTALL_INTERFACE:$<TARGET_NAME_IF_EXISTS:Boost::system>>", ""
      s.gsub! "Boost::system ZLIB::ZLIB", "$<TARGET_NAME_IF_EXISTS:Boost::system> ZLIB::ZLIB"
    end
    inreplace "cmake/avro-cpp-config.cmake.in", boost_replacements, "Boost REQUIRED"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"cpx.json").write <<~JSON
      {
          "type": "record",
          "name": "cpx",
          "fields" : [
              {"name": "re", "type": "double"},
              {"name": "im", "type" : "double"}
          ]
      }
    JSON

    (testpath/"test.cpp").write <<~CPP
      #include "cpx.hh"

      int main() {
        cpx::cpx number;
        return 0;
      }
    CPP

    system bin/"avrogencpp", "-i", "cpx.json", "-o", "cpx.hh", "-n", "cpx"
    system ENV.cxx, "test.cpp", "-std=c++17", "-o", "test"
    system "./test"
  end
end
