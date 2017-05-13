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
    sha256 "c17637f762fa2ec3de8d1a2d335de3fa44b1cae79360df091c95cd28e20836c3" => :sierra
    sha256 "e656fab639c53bada209f91158540218d818c8311e8b097c0e610135efc3b0a1" => :el_capitan
    sha256 "dece3b5e2276e51e614be6c05f649cf972b4796c50cce08b3dda92b01495caa0" => :yosemite
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
