class Cockatrice < Formula
  desc "Cross-platform virtual tabletop for multiplayer card games"
  homepage "https://cockatrice.github.io/"
  url "https://github.com/Cockatrice/Cockatrice.git",
      :tag => "2017-11-19-Release-2.4.0",
      :revision => "4d641eb0e723bf4f83343a3b3c6650a1008793f8"
  version "2.4.0"
  version_scheme 1
  head "https://github.com/Cockatrice/Cockatrice.git"

  bottle do
    sha256 "b758e61b7b75441e4e32b4eb09d95c5756d95f2e1960e9fa5fc7caf2fe7874b5" => :high_sierra
    sha256 "a677a4a67620fe47c14f25a0349ea76b086870ada0cab93aecaf78aff1dea919" => :sierra
    sha256 "bc12c371557059da0a1c277ed49208f495deb817275ca4b82a38e7713a90c99e" => :el_capitan
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
