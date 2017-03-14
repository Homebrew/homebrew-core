class Cockatrice < Formula
  desc "Virtual tabletop for multiplayer card games"
  homepage "https://github.com/Cockatrice/Cockatrice"
  url "https://github.com/Cockatrice/Cockatrice.git",
      :tag => "2017-03-14-Release",
      :revision => "6e723b2a992022ba343d45d881b3c92b9d1c6ba2"
  version "2017-03-14"
  head "https://github.com/Cockatrice/Cockatrice.git"

  bottle do
    sha256 "75fa21c8c692249679a262dbd66f1e105b7182297e66f363e44968512fb0f0a0" => :sierra
    sha256 "fa97822a7217a4b995619cc4745a831e77a23b63987e85620addad1f05e2465a" => :el_capitan
    sha256 "c5497646ed72a5354a9219f846e6bca22fda579d1e665c8c02894e63804ae117" => :yosemite
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
