class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  license "BSD-3-Clause"

  # TODO: Remove `stable` block when patch is no longer needed.
  stable do
    url "https://github.com/protocolbuffers/protobuf/releases/download/v23.2/protobuf-23.2.tar.gz"
    sha256 "ddf8c9c1ffccb7e80afd183b3bd32b3b62f7cc54b106be190bf49f2bc09daab5"

    # Fix missing unexported symbols.
    # https://github.com/protocolbuffers/protobuf/issues/12932
    patch do
      url "https://github.com/protocolbuffers/protobuf/commit/fc1c5512e524e0c00a276aa9a38b2cdb8fdf45c7.patch?full_index=1"
      sha256 "2ef672ecc95e0b35e2ef455ebbbaaaf0d5a89a341b5bbbe541c6285dfca48508"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "0ca2b5b96e59b5932984ad763b82fa1c3ed6fa9f14ae4dda1d7ba819ac8cbb34"
    sha256 cellar: :any,                 arm64_monterey: "e7bfed368f3af001d815d4686f189a4610bc109ab8c83b43d7b02a6f6238b981"
    sha256 cellar: :any,                 arm64_big_sur:  "10d72170b25b4e0729f50138c6c42cf31cb09484c6e9560bfbd0ef7c3b2e19a5"
    sha256 cellar: :any,                 ventura:        "bd64577ce4c4908a60e50db88328ce98ffd1ede84c1111fef470e112eccedbf2"
    sha256 cellar: :any,                 monterey:       "cdcf22bb3d8007a1ec8d1ba0eaa36d22c38fa3c80be4b14a947fa7128186bce9"
    sha256 cellar: :any,                 big_sur:        "6b1627590a556944a41066140234b5edb54c4d50c876990080daf7e5ba4bee4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f21ef3a90ebb7583ecb59650eb89e85aa4de7b1724668773c170d0ec4a485f55"
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
