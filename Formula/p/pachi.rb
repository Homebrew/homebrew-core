class Pachi < Formula
  desc "Software for the Board Game of Go/Weiqi/Baduk"
  homepage "https://pachi.or.cz/"
  url "https://github.com/pasky/pachi/archive/refs/tags/pachi-12.90-homebrew.tar.gz"
  sha256 "786e111a9e2eaf3801ceeebc6f9ae4c21b15c7807992c4894993973b3a5e19cb"
  license all_of: [
    "GPL-2.0-only",
    "BSD-2-Clause", # `caffe`
  ]
  revision 2
  head "https://github.com/pasky/pachi.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "9c680fcecde6bc56ced1e2c279d637e8ff0be40dc926aaaf74f7066d9ebbe821"
    sha256 arm64_sequoia: "28c46d0ac33419c4c2ec6b199f7873b11dad54edc17d8f226c3782f976adab35"
    sha256 arm64_sonoma:  "6b13b8bf52eb3d56894d9b8aa9b45f11ef7adbb5f6c2bbbf8c7d09bbe03397a2"
    sha256 sonoma:        "f1a10b33fa052a03675723ebc485a872f8d1a3b34bb5c6a4fee83fd76ab86f21"
    sha256 arm64_linux:   "e87f49e19878ec55bbed986afb7a64e47d42e5a250a0924f6b6cc5fa42a0ac6d"
    sha256 x86_64_linux:  "00eb1888e290b3ea8a1fd4b637c1daf792166872b58ca13c675d9fa8be053041"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "wget" => :build
  depends_on "boost" # For caffe
  depends_on "gflags" # For caffe
  depends_on "glog" # For caffe
  depends_on "hdf5" # For caffe
  depends_on "katago"
  depends_on "openblas" # For caffe
  depends_on "protobuf" # For caffe

  resource "caffe" do
    url "https://github.com/BVLC/caffe/archive/refs/tags/1.0.tar.gz"
    sha256 "71d3c9eb8a183150f965a465824d01fe82826c22505f7aa314f700ace03fa77f"

    # Modern-toolchain fixes: drop header-only boost::system, update
    # SetTotalBytesLimit for protobuf 3.6+, replace std::random_shuffle.
    patch do
      file "Patches/pachi/caffe-modern-toolchain.patch"
      type :unofficial
    end
  end

  # Fix glog LogSeverity cast, portable rpath.
  patch :DATA

  def install
    caffe_prefix = libexec/"caffe"

    resource("caffe").stage do
      # Abseil (via protobuf) is not on Caffe's default include path.
      ENV.append_to_cflags "-I#{formula_opt_include("abseil")}"

      # Caffe's legacy FindGlog doesn't propagate modern glog's compile
      # definitions, leaving GLOG_EXPORT undefined in <glog/flags.h>.
      ENV.append_to_cflags "-DGLOG_USE_GLOG_EXPORT -DGLOG_USE_GFLAGS"

      # Silence warnings-as-errors from pre-C++14 code on modern Clang.
      ENV.append_to_cflags "-Wno-error -Wno-deprecated-declarations -Wno-unused-but-set-variable"

      args = %w[
        -DCPU_ONLY=ON
        -DBUILD_SHARED_LIBS=ON
        -DBUILD_python=OFF
        -DBUILD_python_layer=OFF
        -DBUILD_matlab=OFF
        -DBUILD_docs=OFF
        -DUSE_OPENCV=OFF
        -DUSE_LMDB=OFF
        -DUSE_LEVELDB=OFF
        -DUSE_NCCL=OFF
        -DBLAS=open
      ]
      # Abseil needs C++17 (std::is_same_v, `if constexpr`).
      args << "-DCMAKE_CXX_STANDARD=17"
      # CMake 4 dropped cmake_minimum_required(2.8.7) compatibility.
      args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

      system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: caffe_prefix), *args
      system "cmake", "--build", "build", "--target", "caffe"
      # Install only what pachi links against; `cmake --install` would fail
      # on a non-existent tools/caffe target.
      (caffe_prefix/"lib").install Dir["build/lib/libcaffe*"]
      (caffe_prefix/"include").install "include/caffe"
      (caffe_prefix/"include/caffe").install "build/include/caffe/proto"
    end

    katago_model = "g170e-b20c256x2-s5303129600-d1228401921.bin.gz" # from resource of katago formula

    inreplace "Makefile" do |s|
      # Release tarballs lack build.h.git, so short-circuit the git-metadata rule
      # Issue ref: https://github.com/pasky/pachi/issues/78
      if build.stable?
        s.gsub! "build.h: build.h.git", "build.h:"
        s.gsub! "@cp build.h.git", "echo '#define PACHI_GIT_BRANCH \"\"\\n#define PACHI_GIT_HASH \"\"' >>"
      end

      s.change_make_var! "PREFIX", prefix

      s.gsub! "BUILD_KATAGO=1", "BUILD_KATAGO=0"
      s.gsub! "$(KATAGO_MODEL_PATH)", "" # Don't install own model, use katago model
      s.change_make_var! "KATAGO_BINARY", "katago"
      s.change_make_var! "KATAGO_MODEL", katago_model
    end

    ENV["MAC"] = "1" if OS.mac?
    ENV["GENERIC"] = "1"
    ENV["DOUBLE_FLOATING"] = "1"
    ENV["CAFFE_PREFIX"] = caffe_prefix.to_s

    system "make"
    system "make", "datafiles"
    system "make", "install"

    # Use opt path to keep the model without revision, not revision when katago is updated.
    ln_s Formula["katago"].opt_pkgshare/katago_model, share/"pachi-go/#{katago_model}"
  end

  test do
    output = pipe_output("#{bin}/pachi -t =500 2>&1", "genmove b\nquit\n", 0)
    assert_match "External engine: KataGo version #{Formula["katago"].version}", output
    assert_match "Loading joseki fixes", output
    assert_match(/^= [A-T][0-9]+$/, output.lines.find { |line| line.start_with?("= ") })

    # Verify dcnn support is compiled
    assert_match "detlef", shell_output("#{bin}/pachi --list-dcnn")
  end
end

__END__
--- a/dcnn/caffe.cpp
+++ b/dcnn/caffe.cpp
@@ -34,7 +34,7 @@
 {
 	google::InitGoogleLogging(argv[0]);
 	google::LogToStderr();
-	google::SetStderrLogging(google::NUM_SEVERITIES - 1);
+	google::SetStderrLogging(static_cast<google::LogSeverity>(google::NUM_SEVERITIES - 1));
 }

 bool
--- a/Makefile
+++ b/Makefile
@@ -268,7 +268,7 @@
 endif

 ifdef CAFFE_PREFIX
-	LDFLAGS  += -L$(CAFFE_PREFIX)/lib -Wl,-rpath=$(CAFFE_PREFIX)/lib
+	LDFLAGS  += -L$(CAFFE_PREFIX)/lib -Wl,-rpath,$(CAFFE_PREFIX)/lib
 	CXXFLAGS += -I$(CAFFE_PREFIX)/include
 endif
