class Cockatrice < Formula
  desc "Cross-platform virtual tabletop for multiplayer card games"
  homepage "https://cockatrice.github.io/"
  url "https://github.com/Cockatrice/Cockatrice.git",
      :tag => "2018-03-02-Release-2.5.0",
      :revision => "5859fa2f20b7bf51249fe5f336ecfd36ef22f324"
  version "2.5.0"
  version_scheme 1
  head "https://github.com/Cockatrice/Cockatrice.git"

  bottle do
    sha256 "a4d55a9b8500a209f45fb6f5dc51575b563f0a371247f9b07771cdbfbb9f5105" => :high_sierra
    sha256 "0375aa07963f3475b613207ea7615f08c296439bf3f832b7c9ce1e0e54996981" => :sierra
    sha256 "29369f9c3fcb3f8c16e738041236b9d7bcbf88a2c28859193a51a605f8833f30" => :el_capitan
  end

  depends_on :macos => :el_capitan
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
  end

  test do
    assert_predicate prefix/"cockatrice.app/Contents/MacOS/cockatrice", :executable?
    assert_predicate prefix/"oracle.app/Contents/MacOS/oracle", :executable?
  end
end
