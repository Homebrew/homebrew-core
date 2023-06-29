class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v23.3/protobuf-23.3.tar.gz"
  sha256 "3a5f47ad3aa10192c5577ff086b24b9739a36937c34ceab6db912a16a3ef7f8e"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "34a7292702d7d7881a51e91a643751f886caf16f55298a1d9bf712aab23ddbbb"
    sha256 cellar: :any,                 arm64_monterey: "e2080ffdc52c3ceda783bd1add6dc24ee68b955dc814d0d05411c768a42535a3"
    sha256 cellar: :any,                 arm64_big_sur:  "721ee01a0f5d281ef504339b5fa6a27d1fdcc145ccff8cf6ef1f185c2d3aab1f"
    sha256 cellar: :any,                 ventura:        "3e9f9b8e5317114d8dccda4e61b2aa00f91ca621663bc10c18886acc55ad4951"
    sha256 cellar: :any,                 monterey:       "d529c07b5c32da9f6ce554b254deb080efb3d52afde57ecea86fc0ad38b6aaf2"
    sha256 cellar: :any,                 big_sur:        "8ea4aec0224f535dbdb15cefb05cfba426ccc5bc79c4fe2a659a8a20cbcb83b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cc5053fb61bc58d4c3bb32724b3c51977e0097872ba60fbeb1d46a292b222ea"
  end

  head do
    url "https://github.com/protocolbuffers/protobuf.git", branch: "main"
    depends_on "jsoncpp"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "abseil"
  # TODO: Add the dependency below in Protobuf 24+. Also remove `head` block.
  # TODO: depends_on "jsoncpp"

  uses_from_macos "zlib"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    odie "Dependencies need adjusting!" if build.stable? && version >= "24"
    # Keep `CMAKE_CXX_STANDARD` in sync with the same variable in `abseil.rb`.
    abseil_cxx_standard = 17
    cmake_args = %w[
      -DBUILD_SHARED_LIBS=ON
      -Dprotobuf_BUILD_LIBPROTOC=ON
      -Dprotobuf_BUILD_SHARED_LIBS=ON
      -Dprotobuf_INSTALL_EXAMPLES=ON
      -Dprotobuf_BUILD_TESTS=OFF
      -Dprotobuf_ABSL_PROVIDER=package
      -Dprotobuf_JSONCPP_PROVIDER=package
    ]
    cmake_args << "-DCMAKE_CXX_STANDARD=#{abseil_cxx_standard}"

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "editors/proto.vim"
    elisp.install "editors/protobuf-mode.el"

    ENV.append_to_cflags "-I#{include}"
    ENV.append_to_cflags "-L#{lib}"
    ENV["PROTOC"] = bin/"protoc"

    cd "python" do
      # Keep C++ standard in sync with `abseil.rb`.
      inreplace "setup.py", "extra_compile_args.append('-std=c++14')",
                            "extra_compile_args.append('-std=c++#{abseil_cxx_standard}')"
      pythons.each do |python|
        pyext_dir = prefix/Language::Python.site_packages(python)/"google/protobuf/pyext"
        with_env(LDFLAGS: "-Wl,-rpath,#{rpath(source: pyext_dir)} #{ENV.ldflags}".strip) do
          system python, *Language::Python.setup_install_args(prefix, python), "--cpp_implementation"
        end
      end
    end
  end

  test do
    testdata = <<~EOS
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    EOS
    (testpath/"test.proto").write testdata
    system bin/"protoc", "test.proto", "--cpp_out=."

    pythons.each do |python|
      system python, "-c", "from google.protobuf.pyext import _message"
    end
  end
end
