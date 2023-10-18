class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v24.4/protobuf-24.4.tar.gz"
  sha256 "616bb3536ac1fff3fb1a141450fa28b875e985712170ea7f1bfe5e5fc41e2cd8"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256                               arm64_sonoma:   "16b8d32784c598f922a6209b18b85a7ef0cbc9c7a1de59313c3dee44c3cf9296"
    sha256                               arm64_ventura:  "fd14e1a0cd0efebaf1c51798f53ad13658c9686f21ad4063118eedb25dccc27e"
    sha256                               arm64_monterey: "bc0e81685716d6a0897316071b320d96a060269aff4e2d7df68d560c1e58de89"
    sha256                               sonoma:         "f6f85b06d6afb0a99a983215fe2042544629005afd36b985497f492bf5e27ba9"
    sha256                               ventura:        "09eb16773501be65bf3794986a56b8209b529d74e42bdfa66fcae52dd9d7478b"
    sha256                               monterey:       "164df1eb986c3ce2d1f0e87166e50980af17229cf9b0e96957dc4e53f385c06c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7d88ba606a87610275907bae0076aa85370532605dfe8ea057094f913514e8e"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "abseil"
  depends_on "jsoncpp"

  uses_from_macos "zlib"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
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

    (share/"vim/vimfiles/syntax").install "editors/proto.vim"
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
