class Libcpuid < Formula
  desc "Small C library for x86 CPU detection and feature extraction"
  homepage "https://github.com/anrieff/libcpuid"
  url "https://github.com/anrieff/libcpuid/releases/download/v0.8.2/libcpuid-0.8.2.tar.gz"
  sha256 "be05cbafa086850a15b7d6f6cee3e72ae73a2b2ac75c0b2c6fc77611dede73b8"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_linux:  "af61a19db58ffe3df890fc79f40d8ce6b24261ce3a5bad74bf33b8b2d1425708"
    sha256 cellar: :any, x86_64_linux: "4475f8da6b5e52c68d2e07b62eb526d491caa8c6a23f2c96d510124acd795b82"
  end

  head do
    url "https://github.com/anrieff/libcpuid.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_macos do
    depends_on arch: :x86_64

    # Can be undeprecated if upstream decides to support arm64 macOS
    # https://docs.brew.sh/Support-Tiers#future-macos-support
    # TODO: Make linux-only when removing macOS support
    deprecate! date: "2025-09-25", because: :unsupported
    disable! date: "2026-09-25", because: :unsupported
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"cpuid_tool"
    assert_path_exists testpath/"raw.txt"
    assert_path_exists testpath/"report.txt"
    assert_match "CPUID is present", File.read(testpath/"report.txt")
  end
end
