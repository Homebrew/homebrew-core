class Libabigail < Formula
  desc "ABI Generic Analysis and Instrumentation Library"
  homepage "https://sourceware.org/libabigail/"
  url "https://mirrors.kernel.org/sourceware/libabigail/libabigail-2.4.tar.xz"
  sha256 "5fe76b6344188a95f693b84e1b8731443d274a4c4b0ebee18fc00d9aedac8509"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 x86_64_linux: "c77997ee5a971a941fb0a2b3daed75ac3336fe85ceeabb03d243322b89fd01c3"
  end

  head do
    url "https://sourceware.org/git/libabigail.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "elfutils"
  depends_on "libxml2"
  depends_on :linux

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    expected_output = <<~EOS
      <abi-corpus version='2.2' path='#{test_fixtures("elf/hello")}' architecture='elf-amd-x86_64'>
        <elf-needed>
          <dependency name='libc.so.6'/>
        </elf-needed>
      </abi-corpus>
    EOS

    assert_equal expected_output, shell_output("#{bin}/abilint #{test_fixtures("elf/hello")}")
  end
end
