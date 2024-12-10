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
    sha256 cellar: :any,                 arm64_sequoia:  "68cc14a37de162f0006e51cd24bf8732037333c8b4f83d93281f5fd027322854"
    sha256 cellar: :any,                 arm64_sonoma:   "43b9420650c17df411a56b9ffa47824c265e909a116f63b5141d700f20ead267"
    sha256 cellar: :any,                 arm64_ventura:  "e3a3876b799400d284f39109717924563302d548de3508b93499047321982e4f"
    sha256 cellar: :any,                 arm64_monterey: "3d840f89e9fbef4334d1f3a1919f6c784ad787a108aabd4f156dd0ad5039add7"
    sha256 cellar: :any,                 sonoma:         "b9193599165f9bd895789f9ea0429f1f1ef0cfeb4768d7cb6857109f8a282f6a"
    sha256 cellar: :any,                 ventura:        "1732eb8f243b23187bfc41604a74e5b8c222489a72944686a97ad8cc9eca034e"
    sha256 cellar: :any,                 monterey:       "b75fd0a64cacf35169c219ebea627c7f6f291a46e9d984b250fc3e4ea3a9acd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c23da0cf62087e7ea7556c6c8359f05f22c97f49e35694dc0269ee8b83d730bd"
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
