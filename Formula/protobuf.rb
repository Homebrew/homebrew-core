class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v22.5/protobuf-22.5.tar.gz"
  sha256 "26859db86e2516bf447b5c73ad484c72016376dad179d96591d489911e09cdc2"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_ventura:  "1f239e8ef2f5a5e28123ab34e9d8fb909f7a0495f296a7fbdd734751afb5150b"
    sha256 cellar: :any,                 arm64_monterey: "8cf9ff7c773a6bcf16a18328c5337d0488795b292d24bdc3e2d7d3313d988c27"
    sha256 cellar: :any,                 arm64_big_sur:  "dbbfa2c402ab0551e6d7adc70be7e600e44b104db1453a8d9031bb7045ff6193"
    sha256 cellar: :any,                 ventura:        "a36fb3face5989e81d7385f7e6099dcf21a6f3aa85bab22d7427849f36484a31"
    sha256 cellar: :any,                 monterey:       "0443caf078d379396097e5f9786dab3da5b925fb5ec02da68e5383fda7dcc155"
    sha256 cellar: :any,                 big_sur:        "6ac6c0e00be578a155a05cdce3c9afc206e7b2a418c61ec9caa80ceb2d61f8c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b915e53de62350858e1aa087cbf753a01655704b1e2991ec8098fc4c017be9f7"
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
      system python, "-c", "import google.protobuf"
    end
  end
end
