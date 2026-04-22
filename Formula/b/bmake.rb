class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20260406.tar.gz"
  sha256 "ed6e5fa0d661ea3c71d12e7481cbbcac6f2bff34051ce36ae7575811766adf26"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2f9b967d88fc7cd1ab38cd26967d86e9dc9d9b33b16972a34c96c6f226a48bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c6fe5864303080967c9bed353737429056b5a58aa7987b05342b55b2acff4c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d975666b331102e7d525bf5341f691eae1e2ff9ef110f5f74ce7f63dffd18dd"
    sha256                               sonoma:        "2cb77f39b4bba016b7a42055fb0d41ea7af2087ec2d2626acdaee9bb868af501"
    sha256                               arm64_linux:   "3e05aa9beae76a6666e13a86cac7e876947603ba2d9201bcf363c8b80f89b672"
    sha256                               x86_64_linux:  "41ef974858a8584ef92953f216eaf7d1f4350198d4df62b014074d5b5c9d88cf"
  end

  uses_from_macos "bc-gh" => :build

  def install
    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    # shell-ksh test segfaults since macOS 11.
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install", "BROKEN_TESTS=shell-ksh"]
    system "sh", "boot-strap", *args

    man1.install "bmake.1"
  end

  test do
    (testpath/"Makefile").write <<~MAKE
      all: hello

      hello:
      	@echo 'Test successful.'

      clean:
      	rm -rf Makefile
    MAKE
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end
