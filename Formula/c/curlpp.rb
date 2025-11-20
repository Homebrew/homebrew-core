class Curlpp < Formula
  desc "C++ wrapper for libcURL"
  homepage "https://www.curlpp.org/"
  url "https://github.com/jpbarrette/curlpp/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "97e3819bdcffc3e4047b6ac57ca14e04af85380bd93afe314bee9dd5c7f46a0a"
  license "MIT"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9a08aba8e10cfb6a543680b097a11d64a4422b7123058bcf8736e71ce334440b"
    sha256 cellar: :any,                 arm64_sequoia: "52b67581206f16051deeb149813b5353107b51044d7d43946426f5d299ef4343"
    sha256 cellar: :any,                 arm64_sonoma:  "ffb42c2d6ac1204ba4179cea16388cf29cac5fd50d6dd610fefaba45aa64fd3a"
    sha256 cellar: :any,                 arm64_ventura: "c9053e831abf0b1097eddc879ca50933409a7a1bd5cbcff29a2f7db8a2e4b327"
    sha256 cellar: :any,                 sonoma:        "5a84433043f3cd206ad6d9e772b8434cb8b297cbfc880640e374f9740cec45e4"
    sha256 cellar: :any,                 ventura:       "4f3de6c2c0b73744aa28d4a1744f7dc79a7155b32e39c7fce99f49e9dc9131ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "373f4b8a4898d60713521a626ebe7133cfeb40680ad167ddf8b4624f4483b925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9983e70bd0a3e56372fd7f83bd535e33840b5169bfd104f44f0b29f0f97d92d1"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  patch do
    # build patch for curl 8.10+
    on_linux do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/curlpp/curl-8.10.patch"
      sha256 "77212f725bc4916432bff3cd6ecf009e6a24dcec31048a9311b02af8c9b7b338"
    end
  end

  def install
    ENV.cxx11
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace bin/"curlpp-config", Superenv.shims_path/ENV.cc, ENV.cc
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <curlpp/cURLpp.hpp>
      #include <curlpp/Easy.hpp>
      #include <curlpp/Options.hpp>
      #include <curlpp/Exception.hpp>

      int main() {
        try {
          curlpp::Cleanup myCleanup;
          curlpp::Easy myHandle;
          myHandle.setOpt(new curlpp::options::Url("https://google.com"));
          myHandle.perform();
        } catch (curlpp::RuntimeError & e) {
          std::cout << e.what() << std::endl;
          return -1;
        } catch (curlpp::LogicError & e) {
          std::cout << e.what() << std::endl;
          return -1;
        }

        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-lcurlpp", "-lcurl"
    system "./test"
  end
end
