class Gitslave < Formula
  desc "Create group of related repos with one as superproject"
  homepage "https://gitslave.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gitslave/gitslave-2.0.2.tar.gz"
  sha256 "8aa3dcb1b50418cc9cee9bee86bb4b279c1c5a34b7adc846697205057d4826f0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8d2048c8edb96fe0dd49b8cd52aa1139f63fb275523022cd2c4e7a6ab45a496a"
    sha256 cellar: :any_skip_relocation, big_sur:       "9975ca2bcb400d61bb8a456c951d9a069cff60f90efa440f211916fbc32bb5b0"
    sha256 cellar: :any_skip_relocation, catalina:      "dd32d79091815434db1c465b3f7caa6c6c346449558d82023a6d88ff92c6ba6b"
    sha256 cellar: :any_skip_relocation, mojave:        "0a6c3ead2d8834fb3e728c06bb72d1102ff516cfafd8283e96b03c5a13a44b89"
    sha256 cellar: :any_skip_relocation, high_sierra:   "53cbfbd7d9f86fa6ee98b46356d76db4c952adbf9e3cf913f0a3136da56bcb69"
    sha256 cellar: :any_skip_relocation, sierra:        "3ccd021a4393d137eed5c0dfdfe94b325b6142258a7090ad04f9166039efa52d"
    sha256 cellar: :any_skip_relocation, el_capitan:    "e556bf6f7ddfa3e9f6a9b726d80a35404270c96e36ada122fd16d8946394aaa6"
    sha256 cellar: :any_skip_relocation, yosemite:      "395794a75f26acdf034f4ab1541cd9af327d13309517e2553bbcb1fdb4bb0f85"
    sha256 cellar: :any_skip_relocation, all:           "f0dc05bf4e295a2a092e5e2df35d108fa33e1b9ebf89c17965abc69ac2897851"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/gits --version")
    assert_match "gits version #{version}", output
  end
end
