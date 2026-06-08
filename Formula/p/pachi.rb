class Pachi < Formula
  desc "Software for the Board Game of Go/Weiqi/Baduk"
  homepage "https://pachi.or.cz/"
  url "https://github.com/pasky/pachi/archive/refs/tags/pachi-12.90-homebrew.tar.gz"
  sha256 "786e111a9e2eaf3801ceeebc6f9ae4c21b15c7807992c4894993973b3a5e19cb"
  license all_of: [
    "GPL-2.0-only",
    "BSD-2-Clause", # `caffe`
  ]
  revision 1
  head "https://github.com/pasky/pachi.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "1bc55f25057fc75c31a45d3887c455d6f74809460ff50695c402ace6a044c7e4"
    sha256 arm64_sequoia: "0f2b0239a24f99166fc25832f2464d75fd762fd3f220b469a777162de0d7a828"
    sha256 arm64_sonoma:  "4a9bdbac1671bb9d336a527e3d6b2a3818d9ecbdc6f8971c8dd97cff1c4055c3"
    sha256 sonoma:        "a874beecf09e5e832bdaca0fe0e11fb42f6c95e22af45e7cdd361c6e240641cd"
    sha256 arm64_linux:   "52ec8533efb4237bdf8df80b2039dffd5bb3e3a2b4ea4f1b53d51f125e62f9c2"
    sha256 x86_64_linux:  "5d5825090f41fb5f6df6bb0cad64e52c84459169e16b72ba00e00e7a04cea2c8"
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
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/ea0b351d/Patches/pachi/caffe-modern-toolchain.patch"
      sha256 "47c872c831ca1bcabe102fd2a68842d2c80086c9f295328e785814fae189d7a4"
    end
  end

  # Fix glog LogSeverity cast, portable rpath.
  patch :DATA

  def install
    caffe_prefix = libexec/"caffe"

    resource("caffe").stage do
      # Abseil (via protobuf) is not on Caffe's default include path.
      ENV.append_to_cflags "-I#{Formula["abseil"].opt_include}"

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
