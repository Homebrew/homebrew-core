class Faust < Formula
  desc "Functional AUdio STream is language for signal processing and synthesis."
  homepage "http://faust.grame.fr"

  url "https://github.com/grame-cncm/faust/archive/v2-1-0.tar.gz"
  sha256 "9bd0b02020a6d9130ac3e2b11ad7cbfc03883769eb87dcb76251c80c40488494"
  head "https://github.com/grame-cncm/faust.git", :branch => "faust2"

  depends_on "pkg-config" => "build"
  depends_on "llvm"
  depends_on "openssl"
  depends_on "libmicrohttpd"
  depends_on "libsndfile"

  def install
    unless build.head?
      inreplace "compiler/Makefile.unix", "else ifeq ($(LLVM_VERSION),$(filter $(LLVM_VERSION), 4.0.0))
    LLVM_VERSION = LLVM_40
    CLANGLIBS=$(CLANGLIBSLIST)
    CXXFLAGS += -std=gnu++11", "else ifeq ($(LLVM_VERSION),$(filter $(LLVM_VERSION), 4.0.0 4.0.1))
    LLVM_VERSION = LLVM_40
    CLANGLIBS=$(CLANGLIBSLIST)
    CXXFLAGS += -std=gnu++11

else ifeq ($(LLVM_VERSION),$(filter $(LLVM_VERSION), 5.0.0))
    LLVM_VERSION = LLVM_50
    CLANGLIBS=$(CLANGLIBSLIST)
    CXXFLAGS += -std=gnu++11"
    end
    system "make world"
    system "make", "install", "PREFIX=#{prefix}"
    if build.with? "test"
      cp_r "tests", prefix
    end
  end
  test do
    cp_r "#{prefix}/tests/architecture-tests", testpath
    cd "#{testpath}/architecture-tests"
    system "./testfailure"
    cd "#{testpath}/architecture-tests"
    system "./testsuccess", "osx"
  end
end
