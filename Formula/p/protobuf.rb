class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v25.3/protobuf-25.3.tar.gz"
  sha256 "d19643d265b978383352b3143f04c0641eea75a75235c111cc01a1350173180e"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "fddad1ce30679b586263d42f6873ad14033bf081f1a02265a2dfd0db6c5b90a9"
    sha256                               arm64_ventura:  "e5f9660c2add8a0b25a739d8733f8e39994627a52c4280fda3f6a6952fd3580c"
    sha256                               arm64_monterey: "25697e79cbf8a2aa5ae3c70e2a03700cd8c071a1731ecc3eb89bcf44e7d70310"
    sha256                               sonoma:         "f39583032815a31f5d31b520e24d70f75755e921235496b29fd1ed964fd6bcb5"
    sha256                               ventura:        "7a1992bf50282507f8a5b707b98f85d02cc95da61b4a77145ecaa7dc48905f5f"
    sha256                               monterey:       "80f58bba003e5b796d80d00a9324326431340a44abcbcf722596db9c95fc7055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56699682719d48c950eb9e0e862669759e974d9120b08b3d004a61fdd4b4bae8"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
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
