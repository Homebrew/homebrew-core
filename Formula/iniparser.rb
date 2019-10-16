class Iniparser < Formula
  desc "Library for parsing ini files"
  homepage "http://ndevilla.free.fr/iniparser/"
  url "https://github.com/ndevilla/iniparser/archive/v4.1.tar.gz"
  sha256 "960daa800dd31d70ba1bacf3ea2d22e8ddfc2906534bf328319495966443f3ae"
  head "https://github.com/ndevilla/iniparser.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bcda9d9c41e5ecf09a748eae0c6054c92ce858df53d835e5454310ea4f731a8c" => :catalina
    sha256 "69dde8e886645f5b89f83f36835c18449afe7f6c4f119d466d7f204e994952c7" => :mojave
    sha256 "cec20d33114e7a5811acb41f9f9a36a411ffd2eebb7d537167b9b541b03fff8d" => :high_sierra
    sha256 "7ad8eb3b8a66c08b78d2d9d3db18bd50e842d1c5962600ad0c9c8244d296dea8" => :sierra
  end

  conflicts_with "fastbit", :because => "Both install `include/dictionary.h`"

  def install
    # Only make the *.a file; the *.so target is useless (and fails).
    system "make", "libiniparser.a", "CC=#{ENV.cc}", "RANLIB=ranlib"
    lib.install "libiniparser.a"
    include.install Dir["src/*.h"]
  end
end
