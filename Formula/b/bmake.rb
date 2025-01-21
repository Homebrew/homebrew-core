class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20241124.tar.gz"
  sha256 "4f66406091c2f85ea964b238d69eb8f71ab4baac9dca4687a71883ba6de4ddb2"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65da734c72c80726b4fdc89260fe99c44c24e891534d9d2eae8f7f2ad3360fdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8370997e485f21221f7a7f3c2a22d35c7e359b48471f352360b906875a5e5cb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa18d6e999d56b306338cacfb3ed95ec97d8b5670389e84b335753ab7964ebc5"
    sha256                               sonoma:        "77e8155f2989b75fbf0685191604c0c0cd008b019cf8eb44280097864d34e7bf"
    sha256                               ventura:       "ccd41984fae0841df3c11bc401cc1fdb7c4ce45f981b00ec3e6d62c3e72feca1"
    sha256                               x86_64_linux:  "cdf207a1f06c32cdd21d43e805ca85d6ed9c86514633f3e8be282ea44b33bf4f"
  end

  uses_from_macos "bc" => :build

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
