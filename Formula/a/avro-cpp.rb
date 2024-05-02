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
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9c18b3e6a70662c65940c9c801ee5922ce4e544bc72d43e46d152c82f2ecf9e8"
    sha256 cellar: :any,                 arm64_ventura:  "383756d16a7283848668dce914fbe1a3c20bdcb940f17aefc164b0bee73bb28b"
    sha256 cellar: :any,                 arm64_monterey: "3bc07ae9ff324a636b14711adf2fba1097a47cc29450349cc5c8aaf46f5495a5"
    sha256 cellar: :any,                 sonoma:         "562b3515afee306e3b66c89cf6821057febf6ab5d7b33e8d750de315e2510b0d"
    sha256 cellar: :any,                 ventura:        "4f83184b24b6d10f6f3112b3d9a60ce118f056ea47f3f220304acc88a76e328f"
    sha256 cellar: :any,                 monterey:       "07b66ac00605ab6f36c1ade022db1f0799bb1c9c473bafe4494970d13bd83ecf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "583938354670ae2694cf6f543a906c471fed38b3c5299b5716302585bb94165b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"

  def install
    cd "lang/c++" do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end
  end

  test do
    (testpath/"cpx.json").write <<~EOS
      {
          "type": "record",
          "name": "cpx",
          "fields" : [
              {"name": "re", "type": "double"},
              {"name": "im", "type" : "double"}
          ]
      }
    EOS
    (testpath/"test.cpp").write <<~EOS
      #include "cpx.hh"

      int main() {
        cpx::cpx number;
        return 0;
      }
    EOS
    system "#{bin}/avrogencpp", "-i", "cpx.json", "-o", "cpx.hh", "-n", "cpx"
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test"
    system "./test"
  end
end
