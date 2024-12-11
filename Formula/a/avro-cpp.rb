class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.12.0/cpp/avro-cpp-1.12.0.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.12.0/cpp/avro-cpp-1.12.0.tar.gz"
  sha256 "f2edf77126a75b0ec1ad166772be058351cea3d74448be7e2cef20050c0f98ab"
  license "Apache-2.0"

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

  resource "fmt" do
    url "https://github.com/fmtlib/fmt/releases/download/10.2.1/fmt-10.2.1.zip"
    sha256 "312151a2d13c8327f5c9c586ac6cf7cddc1658e8f53edae0ec56509c8fa516c9"
  end

  def install
    # Some installed `avro-cpp` headers include `fmt` headers, but code is not compatible with fmt >= 11
    resource("fmt").stage do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    args = %W[
      -DCMAKE_PREFIX_PATH=#{libexec}
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    "`avro-cpp` headers may need to use the bundled `fmt` at #{opt_libexec}"
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
