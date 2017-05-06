class Cockatrice < Formula
  desc "Virtual tabletop for multiplayer card games"
  homepage "https://github.com/Cockatrice/Cockatrice"
  url "https://github.com/Cockatrice/Cockatrice.git",
      :tag => "2017-05-05-Release-2.3.17",
      :revision => "c96f234b6d398cde949a1226fe17014dcc538c93"
  version "2.3.17"
  version_scheme 1
  head "https://github.com/Cockatrice/Cockatrice.git"

  bottle do
    sha256 "356615f5a2bbad45351cc4484743f8616335ffef95d01e2901ca47b09ff1a408" => :sierra
    sha256 "0f453dce61b0bc6fe442f431ac53b895ba4b47de26f50ab89e26f048ea28503c" => :el_capitan
    sha256 "9233b939255152d97a70fcad4e40292584e8a309d36a9ff676b705038756ce21" => :yosemite
  end

  depends_on :macos => :mavericks
  depends_on "cmake" => :build
  depends_on "protobuf"
  depends_on "qt"

  fails_with :clang do
    build 503
    cause "Undefined symbols for architecture x86_64: google::protobuf"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
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
