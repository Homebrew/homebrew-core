class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  license "BSD-3-Clause"
  revision 1

  # TODO: Remove `stable` block when patches are no longer needed.
  stable do
    url "https://github.com/protocolbuffers/protobuf/releases/download/v23.2/protobuf-23.2.tar.gz"
    sha256 "ddf8c9c1ffccb7e80afd183b3bd32b3b62f7cc54b106be190bf49f2bc09daab5"

    # Fix missing unexported symbols.
    # https://github.com/protocolbuffers/protobuf/issues/12932
    patch do
      url "https://github.com/protocolbuffers/protobuf/commit/fc1c5512e524e0c00a276aa9a38b2cdb8fdf45c7.patch?full_index=1"
      sha256 "2ef672ecc95e0b35e2ef455ebbbaaaf0d5a89a341b5bbbe541c6285dfca48508"
    end

    # Use the same ABI for static and shared objects.
    # https://github.com/protocolbuffers/protobuf/pull/12983
    patch do
      url "https://github.com/protocolbuffers/protobuf/commit/4329fde9cf3fab7d1b3a9abe0fbeee1ad8a8b111.patch?full_index=1"
      sha256 "03c52f9207618fcb91cdb8b21dea4b447edcc6ea041f1837b5ff873e6c283b80"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4cdb7f8584aade05baa4e6e1d1d15d792502fc736d45541f74895581e52922d6"
    sha256 cellar: :any,                 arm64_monterey: "41c3598986ddca8f0457ea015592d1aadefd7796a6cbd42ba9e43e352250dd7c"
    sha256 cellar: :any,                 arm64_big_sur:  "198747882058a496a44d64e95672dc9c046065d0b4bc45152b231dbcda4ee62c"
    sha256 cellar: :any,                 ventura:        "b41b9bd0401464695568845d74e3a2be2fa87c66c020f34b5a87e85eb8953acc"
    sha256 cellar: :any,                 monterey:       "baf239188e320c2d2df2dad81099d2b1a69f1db13495a77e0f98ee171e53d3fe"
    sha256 cellar: :any,                 big_sur:        "8630a20e557bcecd345a447b7723d2b56cb51dd6ad41d55f12572ad4d3619c92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "497acba36ca297118e84acc8561f4dcc8722c4a0ebfc675932ca15eecc042c26"
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
