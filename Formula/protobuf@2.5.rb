class ProtobufAT25 < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.bz2"
  sha256 "13bfc5ae543cf3aa180ac2485c0bc89495e3ae711fc6fab4f8ffe90dfb4bb677"

  bottle do
    cellar :any
    sha256 "9b8bd06980b0e7b9b3f86c405f5da1fceac9c756e6d2937fb07646e13cee123e" => :mojave
    sha256 "57b751631332e48464f3547d6608b24422001d7e98f50eb67bc8594f3dfc6284" => :high_sierra
    sha256 "2666bcf184708bdd23c1df2c209f3bf6fcdfe4769e02db878632be3b2267a106" => :sierra
    sha256 "738a1b9437b4fa18d607d9b385e83c5065c683da3aee3d88b7b30c06a85b7960" => :el_capitan
    sha256 "18c6d55b58fa0e9b8d36738f937a86cb2583b7eeb66412905ffe4870f7e5b60b" => :yosemite
  end

  keg_only :versioned_formula

  def install
    # Don't build in debug mode. See:
    # https://github.com/Homebrew/homebrew/issues/9279
    ENV.prepend "CXXFLAGS", "-DNDEBUG"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-zlib"
    system "make"
    system "make", "check" if build.bottle?
    system "make", "install"

    # Install editor support and examples
    doc.install "editors", "examples"
  end

  def caveats; <<~EOS
    Editor support and examples have been installed to:
      #{doc}
  EOS
  end

  test do
    (testpath/"test.proto").write <<~EOS
      package test;
      message TestCase {
        required string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    EOS
    system bin/"protoc", "test.proto", "--cpp_out=."
  end
end
