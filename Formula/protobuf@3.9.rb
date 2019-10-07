class ProtobufAT39 < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf.git",
      :tag      => "v3.9.2",
      :revision => "52b2447247f535663ac1c292e088b4b27d2910ef"
  revision 1

  bottle do
    cellar :any
    sha256 "c1be8ddc974a93cdf6bdeeac56ca03635397d0280adb4388cf228f0fb611ce12" => :mojave
    sha256 "9220693213ecdf0e22c9d965715509cbebfe34289f07d511468c69045b3f33a0" => :high_sierra
    sha256 "a3b58b755c7a238b8b9525d1c91ef4233c9f031a7236d7a9c7d8e8da86d178a3" => :sierra
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    # Don't build in debug mode. See:
    # https://github.com/Homebrew/homebrew/issues/9279
    # https://github.com/protocolbuffers/protobuf/blob/5c24564811c08772d090305be36fae82d8f12bbe/configure.ac#L61
    ENV.prepend "CXXFLAGS", "-DNDEBUG"
    ENV.cxx11

    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-zlib"
    system "make"
    system "make", "check"
    system "make", "install"

    # Install editor support and examples
    doc.install "editors", "examples"
  end

  test do
    testdata = <<~EOS
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase cases = 1;
      }
    EOS
    (testpath/"test.proto").write testdata
    system bin/"protoc", "test.proto", "--cpp_out=."
  end
end
