class Libssh2 < Formula
  desc "C library implementing the SSH2 protocol"
  homepage "https://libssh2.org/"
  url "https://libssh2.org/download/libssh2-1.11.1.tar.gz"
  mirror "https://github.com/libssh2/libssh2/releases/download/libssh2-1.11.1/libssh2-1.11.1.tar.gz"
  mirror "http://download.openpkg.org/components/cache/libssh2/libssh2-1.11.1.tar.gz"
  sha256 "d9ec76cbe34db98eec3539fe2c899d26b0c837cb3eb466a56b0f109cabf658f7"
  license "BSD-3-Clause"
  revision 4
  compatibility_version 1

  livecheck do
    url "https://libssh2.org/download/"
    regex(/href=.*?libssh2[._-]v?(\d+(?:\.\d+)+)\./i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2700fe402d514ccc6de4d21bf893fea1f346c97ff1668a448a1db1aa2e67c900"
    sha256 cellar: :any, arm64_sequoia: "cb769ecbc0bbe4c71dd2c1dfd95b5b44433824065cce6e9a7ba639b835f54263"
    sha256 cellar: :any, arm64_sonoma:  "09fc033c60259a35c9e485134ad1244b130eaee32881a42d0220c6dae70585ae"
    sha256 cellar: :any, tahoe:         "d53208e08777656d275e00f505a50cf1ed2980e0613c5802036002db95c175e9"
    sha256 cellar: :any, sequoia:       "77458987f6ef9dc1a0c888f0ae98705e6e8c2b1073dbf6b314042e814d18e68d"
    sha256 cellar: :any, sonoma:        "75fe7a276a6749ac0b5d41e6887bb520f616c3fb68288913b92699de61844793"
    sha256 cellar: :any, arm64_linux:   "a88a923e03603ee53c0486e6e17f43df283bb10faee8c42ca9c262fdfc12e6e6"
    sha256 cellar: :any, x86_64_linux:  "97de8d2b3b5ba7320aa04d16f11f98e86b79b70906ac8009fe5e4249b2d3c0b0"
  end

  head do
    url "https://github.com/libssh2/libssh2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Backport of https://github.com/libssh2/libssh2/commit/2dae3024897e1898d389835151f4e9606227721d
  # with a call to `LIBSSH2_UNCONST` removed which doesn't exist in 1.11.1.
  # This modification has been vetted and approved at https://github.com/libssh2/libssh2/issues/2125.
  # Patch can be removed with the next release.
  patch do
    file "Patches/libssh2/CVE-2025-15661.patch"
    type :backport
    resolves "CVE-2025-15661"
  end

  # Remove with the next release.
  patch do
    url "https://github.com/libssh2/libssh2/commit/256d04b60d80bf1190e96b0ad1e91b2174d744b1.patch?full_index=1"
    sha256 "7c5fe26b0b58fb3ee3770c8a7648eddec09845fe016eff22b9074451d1a60c34"
    type :backport
    resolves "CVE-2026-7598"
  end

  # Remove with the next release.
  patch do
    url "https://github.com/libssh2/libssh2/commit/17626857d20b3c9a1addfa45979dadcee1cd84a4.patch?full_index=1"
    sha256 "a236d5cfe1995a85c3b036ab16cc2672aa316fd3e1d6299100bcc4c07a539fd7"
    type :backport
    resolves "CVE-2026-55199"
  end

  # Backport of https://github.com/libssh2/libssh2/commit/97acf3dfda80c91c3a8c9f2372546301d4a1a7a8
  # with a simple conflict fixed.
  # Remove with the next release.
  patch do
    file "Patches/libssh2/CVE-2026-55200.patch"
    type :backport
    resolves "CVE-2026-55200"
  end

  # Backport of https://github.com/libssh2/libssh2/commit/34497525929b9a47f03dfb81887ac896202b7e12
  # with ssh2_err changed to the 1.11's _libssh2_error.
  # Remove with the next release.
  patch do
    file "Patches/libssh2/CVE-2026-58050.patch"
    type :backport
    resolves "CVE-2026-58050"
  end

  # Remove with the next release.
  patch do
    url "https://github.com/libssh2/libssh2/commit/a9758da45a52bc8c630ec9493804d0c6ea30b24a.patch?full_index=1"
    sha256 "46cc7c5184d333e93c80a9cac1c86469c17340e6fc0418aecb2d0d8f6eaa5f41"
    type :backport
    resolves "CVE-2026-58051"
  end

  # Backport of https://github.com/libssh2/libssh2/commit/5e4776146552d898b9c0e1b313cd093fa8dc92d0
  # with a simple conflict fixed.
  # Remove with the next release.
  patch do
    file "Patches/libssh2/CVE-2026-66032.patch"
    type :backport
    resolves "CVE-2026-66032"
  end

  # Remove with the next release.
  patch do
    url "https://github.com/libssh2/libssh2/commit/a2ed82d40964bbc0d64cd717aa0a5a892117d2e6.patch?full_index=1"
    sha256 "378b5f95f1a410afb790c57ceb67f2d4bd15cc42fc1db58d19fe26fd6f8acbed"
    type :backport
    resolves "CVE-2026-66033"
  end

  # Backport of https://github.com/libssh2/libssh2/commit/a13bb6c773f0d55ad1628cede57e99803cd898d9
  # with ssh2_err changed to the 1.11's _libssh2_error.
  # Remove with the next release.
  patch do
    file "Patches/libssh2/CVE-2026-66034.patch"
    type :backport
    resolves "CVE-2026-66034"
  end

  # Backport of https://github.com/libssh2/libssh2/commit/42e33d81577ed4b95d4b4f6f845e5ee8efe5eeb4
  # with simple conflicts fixed and SSH2_SAFEFREE changed to the 1.11's LIBSSH2_FREE + `ptr = NULL`.
  # Remove with the next release.
  patch do
    file "Patches/libssh2/CVE-2026-66035.patch"
    type :backport
    resolves "CVE-2026-66035"
  end

  def install
    args = %W[
      --disable-silent-rules
      --disable-examples-build
      --with-openssl
      --with-libz
      --with-libssl-prefix=#{formula_opt_prefix("openssl@3")}
    ]

    system "./buildconf" if build.head?
    system "./configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libssh2.h>

      int main(void)
      {
      libssh2_exit();
      return 0;
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-lssh2", "-o", "test"
    system "./test"
  end
end
