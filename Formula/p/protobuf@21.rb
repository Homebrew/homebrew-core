class ProtobufAT21 < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v21.12/protobuf-all-21.12.tar.gz"
  sha256 "2c6a36c7b5a55accae063667ef3c55f2642e67476d96d355ff0acb13dbb47f09"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sonoma:   "efac77abd432d15026b826cf010a16296ea2198d13e00ed4de78941f7edda382"
    sha256 cellar: :any,                 arm64_ventura:  "d0909077ab9abd27d47a7990c7bcea6622805421de263ff5a5366beef171bf74"
    sha256 cellar: :any,                 arm64_monterey: "4f147f89429d04ac3ed6c2c8265b0c1915e00fe220e54725e6b0619de22bb4b7"
    sha256 cellar: :any,                 arm64_big_sur:  "8f82f5c9e0fd457a11bbd8d5932a7beab5b816d1dd295ccf2a700f845b29e015"
    sha256                               sonoma:         "f36fdce6e6e6fc81e17eb73f2d6ceac5ca5ce68d6e01347f26faa4cc5ee09be9"
    sha256 cellar: :any,                 ventura:        "3f04c152bc512c647617a667557ba211f3cbabb49a0029c04214488ce52840c6"
    sha256 cellar: :any,                 monterey:       "d273a25298c6bb40374e7741ef20047d62b975fbb55840aa88b63f6d0e687e3d"
    sha256 cellar: :any,                 big_sur:        "76f714caba9825918e0456538f14b8945f7a595b71e205a662ae9ce4f3515dbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57404e662da5768d45c06790cd227171205fcc0e1f775d4e1f2a91cad8ec45cc"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  uses_from_macos "zlib"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  # Fix build with python@3.11
  patch do
    url "https://github.com/protocolbuffers/protobuf/commit/da973aff2adab60a9e516d3202c111dbdde1a50f.patch?full_index=1"
    sha256 "911925e427a396fa5e54354db8324c0178f5c602b3f819f7d471bb569cc34f53"
  end

  def install
    cmake_args = %w[
      -Dprotobuf_BUILD_LIBPROTOC=ON
      -Dprotobuf_INSTALL_EXAMPLES=ON
      -Dprotobuf_BUILD_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-Dprotobuf_BUILD_SHARED_LIBS=ON",
                    *cmake_args, *std_cmake_args
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
                     *cmake_args, *std_cmake_args
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
      with_env(PYTHONPATH: (prefix/Language::Python.site_packages(python)).to_s) do
        system python, "-c", "import google.protobuf"
      end
    end
  end
end
