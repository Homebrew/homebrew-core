class Neko < Formula
  desc "High-level, dynamically typed programming language"
  homepage "https://nekovm.org/"
  url "https://github.com/HaxeFoundation/neko/archive/v2-3-0/neko-2.3.0.tar.gz"
  sha256 "850e7e317bdaf24ed652efeff89c1cb21380ca19f20e68a296c84f6bad4ee995"
  license "MIT"
  revision 4
  head "https://github.com/HaxeFoundation/neko.git"

  bottle do
    cellar :any
    sha256 "232fae50c371bc3ed8c560c08ac6a8da6e69099c7ff31d3e31652f2114dcbb2f" => :big_sur
    sha256 "8f4a846bcb9edbd9d001e7e1eda1acdb217108c962d2e7c2789368c0b09d20c1" => :catalina
    sha256 "a5aa3adb6b6a3175e2ac29d5e6176cc6644b3a751bc339e653d39304f19ea0c2" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "mbedtls"
  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  # Don't redefine MSG_NOSIGNAL -- https://github.com/HaxeFoundation/neko/pull/217
  patch do
    url "https://github.com/HaxeFoundation/neko/commit/24a5e8658a104ae0f3afe66ef1906bb7ef474bfa.patch?full_index=1"
    sha256 "1a707e44b7c1596c4514e896211356d1b35d4e4b578b14b61169a7be47e91ccc"
  end

  # Fix -Wimplicit-function-declaration issue in libs/ui/ui.c
  # https://github.com/HaxeFoundation/neko/pull/218
  patch do
    url "https://github.com/HaxeFoundation/neko/commit/908149f06db782f6f1aa35723d6a403472a2d830.patch?full_index=1"
    sha256 "3e9605cccf56a2bdc49ff6812eb56f3baeb58e5359601a8215d1b704212d2abb"
  end

  # Fix -Wimplicit-function-declaration issue in libs/std/process.c
  # https://github.com/HaxeFoundation/neko/pull/219
  patch do
    url "https://github.com/HaxeFoundation/neko/commit/1a4bfc62122aef27ce4bf27122ed6064399efdc4.patch?full_index=1"
    sha256 "7fbe2f67e076efa2d7aa200456d4e5cc1e06d21f78ac5f2eed183f3fcce5db96"
  end

  def install
    inreplace "libs/mysql/CMakeLists.txt",
              %r{https://downloads.mariadb.org/f/},
              "https://downloads.mariadb.com/Connectors/c/"

    # Workaround issue where lock_acquire(), lock_try(), and lock_release()
    # conflict with some symbols in Mach headers:
    #   https://github.com/HaxeFoundation/neko/issues/215#issuecomment-745617663
    inreplace %w[vm/neko.h.in vm/others.c vm/threads.c libs/ui/ui.c], /\slock_/, " HOMEBREW_lock_"

    # Work around for https://github.com/HaxeFoundation/neko/issues/216 where
    # maria-connector fails to detect the location of iconv.dylib on Big Sur.
    # Also, no reason for maria-connector to compile its own version of zlib,
    # just link against the system copy.
    inreplace "libs/mysql/CMakeLists.txt",
              "-Wno-dev",
              "-Wno-dev -DICONV_LIBRARIES=-liconv -DICONV_INCLUDE_DIR= -DWITH_EXTERNAL_ZLIB=1"

    # Let cmake download its own copy of MariaDBConnector during build and statically link it.
    # It is because there is no easy way to define we just need any one of mariadb, mariadb-connector-c,
    # mysql, and mysql-client.
    system "cmake", ".", "-G", "Ninja", "-DSTATIC_DEPS=MariaDBConnector",
           "-DRELOCATABLE=OFF", "-DRUN_LDCONFIG=OFF", *std_cmake_args
    system "ninja", "install"
  end

  def caveats
    s = ""
    if HOMEBREW_PREFIX.to_s != "/usr/local"
      s << <<~EOS
        You must add the following line to your .bashrc or equivalent:
          export NEKOPATH="#{HOMEBREW_PREFIX}/lib/neko"
      EOS
    end
    s
  end

  test do
    ENV["NEKOPATH"] = "#{HOMEBREW_PREFIX}/lib/neko"
    system "#{bin}/neko", "-version"
    (testpath/"hello.neko").write '$print("Hello world!\n");'
    system "#{bin}/nekoc", "hello.neko"
    assert_equal "Hello world!\n", shell_output("#{bin}/neko hello")
  end
end
