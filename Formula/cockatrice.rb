class Cockatrice < Formula
  desc "Virtual tabletop for multiplayer card games"
  homepage "https://github.com/Cockatrice/Cockatrice"
  url "https://github.com/Cockatrice/Cockatrice.git",
      :tag => "2017-05-05-Release-2.3.17",
      :revision => "c96f234b6d398cde949a1226fe17014dcc538c93"
  version "2.3.17"
  revision 1
  version_scheme 1
  head "https://github.com/Cockatrice/Cockatrice.git"

  bottle do
    sha256 "714abed702cc11fe15727278f9feca8d3c231444c8894c5234678b95bd793d85" => :sierra
    sha256 "f72457bf545e44d9b8b9252d8459bfc16f1eb00d3242b6649508053f158b4dc6" => :el_capitan
    sha256 "a56d73a6cf4bf1ad4dd39747fdc2afc757be2fcd6f86997a4b4f8a752a47f8cf" => :yosemite
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
