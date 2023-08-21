class Libabigail < Formula
  desc "ABI Generic Analysis and Instrumentation Library"
  homepage "https://sourceware.org/libabigail/"
  url "https://mirrors.kernel.org/sourceware/libabigail/libabigail-2.3.tar.xz"
  sha256 "bc214c89f3b7ab8f20113a7c7aa40a207d41574d7ec25c2520501420d8019eb0"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 x86_64_linux: "cb5c436669736319907ae4b9cc16c0f6549f86e3a01c0d8488bb4b33fc0c47c2"
  end

  head do
    url "https://sourceware.org/git/libabigail.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "elfutils"
  depends_on :linux

  uses_from_macos "libxml2"

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
