class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v0.24.2.tar.gz"
  sha256 "00f0a7403143fba69601accc80cacf49becc568b890ba232f300c1b2a37475e6"
  head "https://github.com/libgit2/libgit2.git"

  bottle do
    sha256 "5edc114bf73497bfcbf99604396ab221164f0b697286710dce9c47bab17deb84" => :sierra
    sha256 "e0163bb10778e218f79d9b2f6e23684c21718dc32ff83b02987537b2c220d590" => :el_capitan
    sha256 "5a4960a681598dfd3c9ba0973c5cdcb338dc1ba28a7794972f423f3428c15265" => :yosemite
    sha256 "b570c202f7a2438b98cbcda66ba36c57026e47623d74ca5ba4cb728b7660e9a5" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "libssh2" => :recommended
  depends_on "openssl" if MacOS.version <= :lion # Uses SecureTransport on >10.7

  def install
    args = std_cmake_args
    args << "-DBUILD_EXAMPLES=YES"
    args << "-DBUILD_CLAR=NO" # Don't build tests.
    args << "-DUSE_SSH=NO" if build.without? "libssh2"

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      cd "examples" do
        (pkgshare/"examples").install "add", "blame", "cat-file", "cgit2",
                                      "describe", "diff", "for-each-ref",
                                      "general", "init", "log", "remote",
                                      "rev-list", "rev-parse", "showindex",
                                      "status", "tag"
      end
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <git2.h>

      int main(int argc, char *argv[]) {
        int options = git_libgit2_features();
        return 0;
      }
    EOS
    libssh2 = Formula["libssh2"]
    flags = %W[
      -I#{include}
      -I#{libssh2.opt_include}
      -L#{lib}
      -lgit2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
