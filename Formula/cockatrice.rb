class Cockatrice < Formula
  desc "Cross-platform virtual tabletop for multiplayer card games"
  homepage "https://cockatrice.github.io/"
  url "https://github.com/Cockatrice/Cockatrice.git",
      :tag => "2018-06-17-Release-2.6.0",
      :revision => "c7072cd543fd2972433bd1f8cf4f5023b8d157c1"
  version "2.6.0"
  version_scheme 1
  head "https://github.com/Cockatrice/Cockatrice.git"

  bottle do
    sha256 "53735801927211e1861f0b0a242a25d9667641f3ac17452864e35d731c56b9da" => :high_sierra
    sha256 "cec16509611d2e1e98446820e1e5e6552c91d90d33f084a27f6d3c0033ade7d6" => :sierra
    sha256 "cbf9ff507467ecbe3935505cb9c245b46a69ac4518e09ff83416f41698331b72" => :el_capitan
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
