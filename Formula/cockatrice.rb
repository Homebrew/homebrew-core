class Cockatrice < Formula
  desc "Virtual tabletop for multiplayer card games"
  homepage "https://github.com/Cockatrice/Cockatrice"
  url "https://github.com/Cockatrice/Cockatrice.git",
      :tag => "2017-03-14-Release",
      :revision => "6e723b2a992022ba343d45d881b3c92b9d1c6ba2"
  version "2017-03-14"
  head "https://github.com/Cockatrice/Cockatrice.git"

  bottle do
    sha256 "2af03423fcf74a3f52b64acf9d0658efbb5b3ebd4a7cab80f92dbadb5ad0d6ef" => :sierra
    sha256 "842d28f0b947e2d502b5c87d89dcf488a2f9a31d3cfe86a928a48b93a9cf8559" => :el_capitan
    sha256 "4623ff8fd4c772a8c653c2b7dfa7be932621b659bbe2893b776c78b5389f95e2" => :yosemite
  end

  option "with-server", "Build `servatrice` for running game servers"

  depends_on :macos => :mavericks
  depends_on "cmake" => :build
  depends_on "protobuf"

  if build.with? "server"
    depends_on "qt5" => "with-mysql"
  else
    depends_on "qt5"
  end

  fails_with :clang do
    build 503
    cause "Undefined symbols for architecture x86_64: google::protobuf"
  end

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DWITH_SERVER=ON" if build.with? "server"
      system "cmake", "..", *args
      system "make", "install"
      prefix.install Dir["release/*.app"]
    end
    doc.install Dir["doc/usermanual/*"]
  end

  test do
    (prefix/"cockatrice.app/Contents/MacOS/cockatrice").executable?
    (prefix/"oracle.app/Contents/MacOS/oracle").executable?
  end
end
