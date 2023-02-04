class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf.git", branch: "main"

  stable do
    url "https://github.com/protocolbuffers/protobuf/releases/download/v21.12/protobuf-all-21.12.tar.gz"
    sha256 "2c6a36c7b5a55accae063667ef3c55f2642e67476d96d355ff0acb13dbb47f09"

    # Fix build with Python 3.11. Remove in the next release.
    patch do
      url "https://github.com/protocolbuffers/protobuf/commit/da973aff2adab60a9e516d3202c111dbdde1a50f.patch?full_index=1"
      sha256 "911925e427a396fa5e54354db8324c0178f5c602b3f819f7d471bb569cc34f53"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2bc9d7a7861c606fc5bdd6dc02cf047557cfe872f747d61fe38aab53cb9f2e54"
    sha256 cellar: :any,                 arm64_monterey: "b0f40d63aefc10a35e1a81b6b998b1a9f6c46cc8513d0c1fd463e6fa0cf14807"
    sha256 cellar: :any,                 arm64_big_sur:  "ad43c084c9debebb22b5bb3cfe26af9db78bd059175708181f0c11bcb51cf154"
    sha256 cellar: :any,                 ventura:        "7e09c446953814de923998a375bb795af4eeeb7b746bc5bd308d9a62999c90f0"
    sha256 cellar: :any,                 monterey:       "c00b5dd720d7beb66723bef40b42b39a1e098d2e6b17d08b0580a31232bc4323"
    sha256 cellar: :any,                 big_sur:        "49517cb1603bc16c30d514ae3d84be7ee54fca252cb86734b289b56abb6c5c37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13a477c4b847bdb0a0f7fe06b65ba816c083152b946a55744bb41bb2921aef31"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]

  uses_from_macos "zlib"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    cmake_args = %w[
      -Dprotobuf_BUILD_LIBPROTOC=ON
      -Dprotobuf_BUILD_SHARED_LIBS=ON
      -Dprotobuf_INSTALL_EXAMPLES=ON
      -Dprotobuf_BUILD_TESTS=OFF
    ] + std_cmake_args

    system "cmake", "-S", ".", "-B", "build", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "editors/proto.vim"
    elisp.install "editors/protobuf-mode.el"

    ENV.append_to_cflags "-I#{include}"
    ENV.append_to_cflags "-L#{lib}"
    ENV["PROTOC"] = bin/"protoc"

    cd "python" do
      pythons.each do |python|
        system python, *Language::Python.setup_install_args(prefix, python), "--cpp_implementation"
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
