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

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "32db92862f12a23013f63a95d411110dd6dcdd4875f31ae65a958a59782e1a49"
    sha256 cellar: :any,                 arm64_ventura:  "88356a4c1bfa87b2f556d042b3474382937aaaf3ba88fa37da576c35be852c51"
    sha256 cellar: :any,                 arm64_monterey: "e5fef24dc87ea2120ff9ffb349c6c702da410a761cd2e9a51a94f9b5495ce5e8"
    sha256 cellar: :any,                 sonoma:         "9255403242355b0883b5a79c3892aab8b5cbdf015ef0ade4257cbdc8b8ec966a"
    sha256 cellar: :any,                 ventura:        "f4d9f45068be9faceee6831a252e697e492ed47aa353fad94f83e2b572d5d63f"
    sha256 cellar: :any,                 monterey:       "2852fbbf0cbd97fc4574a8547cd1833d1dacd402b99636ec82016bb44d53c126"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "063c11e86cdc61875124d9433379ff9f15285eee4bd281c63a61b0c2dd21a7b2"
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
