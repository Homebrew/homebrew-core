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
    sha256 "c42f80f3269a7226b40e52cf3af6be44b3952882c2d0c235b536120552c9d550" => :high_sierra
    sha256 "67373a44512d250598df6cbe3f29c121c54519ea55233635f0d7991eee522f7c" => :sierra
    sha256 "6caa34c3b0aed2e8451637eea27bc0f819924bec2d07bb22b7919730246d1b05" => :el_capitan
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
