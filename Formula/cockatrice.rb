class Cockatrice < Formula
  desc "Virtual tabletop for multiplayer card games"
  homepage "https://github.com/Cockatrice/Cockatrice"
  url "https://github.com/Cockatrice/Cockatrice.git",
      :tag => "2017-03-14-Release",
      :revision => "6e723b2a992022ba343d45d881b3c92b9d1c6ba2"
  version "2017-03-14"
  revision 1
  head "https://github.com/Cockatrice/Cockatrice.git"

  bottle do
    sha256 "74bf12a26451a88ee057fa7b0d072b8857551b83593fc99ce49a3356056d9c0c" => :sierra
    sha256 "509b095190997623cbc2aa0643b64ef1c0684895aee74ac9324b0c6b9b5af690" => :el_capitan
    sha256 "118b7e64667421cc4856152c1143846675248b99eec7d4ca761e1e59e38a99b2" => :yosemite
  end

  option "with-server", "Build `servatrice` for running game servers"

  depends_on :macos => :mavericks
  depends_on "cmake" => :build
  depends_on "protobuf"

  if build.with? "server"
    depends_on "qt" => "with-mysql"
  else
    depends_on "qt"
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
