class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20250125.tar.gz"
  sha256 "4c7db7d04dbbfad00e57adc750cdd183095cc494bbeaf9daf338415cb5a599b2"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a9c3aad2eb28b01f0372c90a02a9909e04aed379f031ad058c4b917f6609c4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6577add099e87c65b506a08bd342e75864dac0f29d79b204484a2de6d0bdb66b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f7495a742b4e4f3a6bdb5e4d062f5b28c3d2155acb8cb5e249d810edc01fe1b"
    sha256                               sonoma:        "ca25aff5b24c3b53b14be96c8f560e03481904fc1bb897047dafcc7b93a5cb9b"
    sha256                               ventura:       "ed4fd1977d1c840ac610f35b4574f5bf76718dd9ae2f4b2ed9c8299f688ce36f"
    sha256                               x86_64_linux:  "c205f62896d355106beb59ac6e56a3d979d187c5a56cbc2f2b2c66b3c945b5a6"
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
