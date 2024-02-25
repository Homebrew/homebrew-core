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
    sha256                               arm64_sonoma:   "11544609db3c460e2f29f925c635a2fa14cbaed95605382fec8841c2b38180c5"
    sha256                               arm64_ventura:  "d343361f14902afbecfa33b37a9acc07633aaf0c89290b26ab50d4e55c83e87d"
    sha256                               arm64_monterey: "34f598e55fc7be32c351346a971c464e3b4ddb7a48b5eb170cae8639b40afdcd"
    sha256                               sonoma:         "8ed910199ee7b9773922150c453a91a23496612626fbf8750b82ed10e79fc00d"
    sha256                               ventura:        "cbb17db9cb927c4c2cd8d45cce6059f946235aba3f71336bf32712243d421135"
    sha256                               monterey:       "3ce77e5911489450ca43fea3331afdc7614efc2df48d1f381e19209cb767994e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2da46e3fff8eaaa62bb26248686abb3f5d939b1145b2cef2af8eabaa5132cf7e"
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
