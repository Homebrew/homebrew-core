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
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "09fdc2fccabd91f0d73ffd8226103dac311967d5ebad48b84ea1fd6a6cbb78eb"
    sha256 cellar: :any,                 arm64_monterey: "c4c1fdb19df1fbb57cad3b625133b3f2fe6b35247ac95ebfef9b0e029224eaa6"
    sha256 cellar: :any,                 arm64_big_sur:  "d01fc51afbb4217d6e2631af2a31723998e1f1c17c3e08d5c3650e3bf25ceb3a"
    sha256 cellar: :any,                 ventura:        "a9ff1abd6d7cb46a2b6e4e57104eec1e37649fd67b8c7cb5e404408a8b707ac6"
    sha256 cellar: :any,                 monterey:       "577987b80fc473c72bdada210d6097f66385cf1d5b685c58b7532cff2aa6b499"
    sha256 cellar: :any,                 big_sur:        "919e2c99d9378da69ff8ea0a293787e5111cac258d58397901578d3c7b59db17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b816d47da681c53338553ca2deb18c647539d66a8dcfac8afc92bafcc285428"
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
