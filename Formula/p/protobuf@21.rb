class ProtobufAT21 < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v21.12/protobuf-all-21.12.tar.gz"
  sha256 "2c6a36c7b5a55accae063667ef3c55f2642e67476d96d355ff0acb13dbb47f09"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256                               arm64_sonoma:   "bc82f299ae0fffa1e5b4e93ec3dd39f0330bb06a8dfdebbb953479de3b25eb00"
    sha256                               arm64_ventura:  "a91538d1878eab72aaa22230709c372f41322377b297c6e01caf188e4e81e378"
    sha256                               arm64_monterey: "ffa13baa9584681115c2b3b0e7f6d56b6e72144aaa13bd9d924ffc0c88bbde87"
    sha256                               sonoma:         "7ed1bf5fadc538bfbe3be0aa42bfb07673c17473ebb44df48f2c12bcafeeeafc"
    sha256                               ventura:        "9b685e87a6ee34e84780544c5573a22c91ee3599f59101eb6a740e65d62f205b"
    sha256                               monterey:       "83eb3a71bf22ea6876506e12697bda4db2fe0140ec4a343ddbeed8109c696fc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4c906d41417f83d39e308e347f6d6c041f79ff7d63d0c7405127ee7186b9477"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
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
