class Cockatrice < Formula
  desc "Virtual tabletop for multiplayer card games"
  homepage "https://github.com/Cockatrice/Cockatrice"
  url "https://github.com/Cockatrice/Cockatrice.git",
      :tag => "2017-01-20-Release",
      :revision => "dab731656dd5856ca293e2660e142cc215acc66e"
  version "2017-01-20"
  head "https://github.com/Cockatrice/Cockatrice.git"

  bottle do
    sha256 "28ca464cbca6f17fc400492e4de9469c2fc173d3606e69bb5b95e5e6a8e5a79d" => :sierra
    sha256 "34452dcfaa59ae77aa4b99f6c53f61b6fdbccef073c7ee5cefdb7710123089b2" => :el_capitan
    sha256 "08ec954750f83ec2f3ff9d79d078072830ed8e68aa32c8cbfbd15538e0197d2f" => :yosemite
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
