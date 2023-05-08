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
    rebuild 3
    sha256 cellar: :any,                 arm64_ventura:  "1f239e8ef2f5a5e28123ab34e9d8fb909f7a0495f296a7fbdd734751afb5150b"
    sha256 cellar: :any,                 arm64_monterey: "8cf9ff7c773a6bcf16a18328c5337d0488795b292d24bdc3e2d7d3313d988c27"
    sha256 cellar: :any,                 arm64_big_sur:  "dbbfa2c402ab0551e6d7adc70be7e600e44b104db1453a8d9031bb7045ff6193"
    sha256 cellar: :any,                 ventura:        "a36fb3face5989e81d7385f7e6099dcf21a6f3aa85bab22d7427849f36484a31"
    sha256 cellar: :any,                 monterey:       "0443caf078d379396097e5f9786dab3da5b925fb5ec02da68e5383fda7dcc155"
    sha256 cellar: :any,                 big_sur:        "6ac6c0e00be578a155a05cdce3c9afc206e7b2a418c61ec9caa80ceb2d61f8c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b915e53de62350858e1aa087cbf753a01655704b1e2991ec8098fc4c017be9f7"
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
      -Dprotobuf_INSTALL_EXAMPLES=ON
      -Dprotobuf_BUILD_TESTS=OFF
    ] + std_cmake_args

    system "cmake", "-S", ".", "-B", "build", "-Dprotobuf_BUILD_SHARED_LIBS=ON", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "editors/proto.vim"
    elisp.install "editors/protobuf-mode.el"

    ENV.append_to_cflags "-I#{include}"
    ENV.append_to_cflags "-L#{lib}"
    ENV["PROTOC"] = bin/"protoc"

    cd "python" do
      pythons.each do |python|
        pyext_dir = prefix/Language::Python.site_packages(python)/"google/protobuf/pyext"
        with_env(LDFLAGS: "-Wl,-rpath,#{rpath(source: pyext_dir)} #{ENV.ldflags}".strip) do
          system python, *Language::Python.setup_install_args(prefix, python), "--cpp_implementation"
        end
      end
    end

    system "cmake", "-S", ".", "-B", "static",
                    "-Dprotobuf_BUILD_SHARED_LIBS=OFF",
                    "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
                    "-DWITH_PROTOC=#{bin}/protoc",
                    *cmake_args
    system "cmake", "--build", "static"
    lib.install buildpath.glob("static/*.a")
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
