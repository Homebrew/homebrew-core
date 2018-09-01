class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.3.13.tar.gz"
  sha256 "dc14c28bfbe0beef5ec93b4614a00bd419d5a793c8a678ba3b5544bd1dd580b6"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    cellar :any
    sha256 "93a54f20fddef879b80fe80d67e21fe87442efcf0e3b0a78c73c581c7e84dd05" => :mojave
    sha256 "20e01b1d5e5f0aea6051396f9aade81ac12175048639c5701406fbb211aaed71" => :high_sierra
    sha256 "ad63b4ee2ca60eba9f30fefc1858c4923003f230f057e77d28fd7572c6e0048d" => :sierra
    sha256 "ceb5198d21c4f266c7edd11ebd2331995bfe3a57c4f6ed7656ddfe230457485c" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "python@2"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/bear", "true"
    assert_predicate testpath/"compile_commands.json", :exist?
  end
end
