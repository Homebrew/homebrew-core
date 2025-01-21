class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  # Upstreams tar.gz can't be opened by bsdtar on macOS
  # https://github.com/Homebrew/homebrew-core/pull/146296#issuecomment-1737945877
  # https://apple.stackexchange.com/questions/197839/why-is-extracting-this-tgz-throwing-an-error-on-my-mac-but-not-on-linux
  url "https://github.com/apache/avro.git",
      tag:      "release-1.11.3",
      revision: "35ff8b997738e4d983871902d47bfb67b3250734"
  license "Apache-2.0"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e73e3635f152d88ce0c8da13877b5209a603e36827041ec5c720753b30a2a17c"
    sha256 cellar: :any,                 arm64_sonoma:  "1a2c2abbaf8b968a600372c87a5a6a0a43a20e0700630d6b8678238cf4816313"
    sha256 cellar: :any,                 arm64_ventura: "a0a70dd6e799584704493d3e69398742b6ec82053f8a26b910c266b36e45d192"
    sha256 cellar: :any,                 sonoma:        "138264d7b172c9239e1cc417ae89d7df6f8e15dacd932700b15e426f395f664f"
    sha256 cellar: :any,                 ventura:       "a19fac27486d0554f54542a95e7eb8eb5a1198889e61900faab846951a121aee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01fecf30ba2081ab2b4ac52e800ba0d3323a28b85b20b291f557c8b2027e576c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"

  def install
    system "cmake", "-S", "lang/c++", "-B", "build", "-DCMAKE_CXX_STANDARD=14", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"cpx.json").write <<~JSON
      {
          "type": "record",
          "name": "cpx",
          "fields" : [
              {"name": "re", "type": "double"},
              {"name": "im", "type" : "double"}
          ]
      }
    JSON

    (testpath/"test.cpp").write <<~CPP
      #include "cpx.hh"

      int main() {
        cpx::cpx number;
        return 0;
      }
    CPP

    system bin/"avrogencpp", "-i", "cpx.json", "-o", "cpx.hh", "-n", "cpx"
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test"
    system "./test"
  end
end
