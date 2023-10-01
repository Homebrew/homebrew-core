class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v24.3/protobuf-24.3.tar.gz"
  sha256 "07d69502e58248927b58c7d7e7424135272ba5b2852a753ab6b67e62d2d29355"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "a94ddfce59d4a9d48a8246faf48dc59a79cfd2d8d1a042443373db4408b58e99"
    sha256                               arm64_ventura:  "b74655262679e566c39e14d538f04ff5e536ed2cb5f9b0b4339aaaa479d48858"
    sha256                               arm64_monterey: "c1c4c31e1a8379e00151b75a3de75bc314f23fc5260a5f39414dca6ec4106fa2"
    sha256                               arm64_big_sur:  "ae1a7d779efdc90d4f739835e6f409b14ef8a49f2fdf371541f296a2e0af1fb7"
    sha256                               sonoma:         "6540683f632be116e9f8161b98ac49a76b1fab527fe10ddd123557eede227176"
    sha256                               ventura:        "38ef2ed336542514b1aa044c24dd35b8912f0fe51e8d8bd3a77e4dcfa2533214"
    sha256                               monterey:       "e8b7f49a6dee6024aaf30a813537b694cc08be62e6b32bc8018ef17cc860ae88"
    sha256                               big_sur:        "40d988730fd3a9cbbf00370f7292322600f7ecdcd67cd5b32336ded78cc1d5ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "440ba0363e77bd10573ead029ea50c2274b9cac0afc33ac68073100713597f15"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
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
