class Gitslave < Formula
  desc "Create group of related repos with one as superproject"
  homepage "https://gitslave.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gitslave/gitslave-2.0.2.tar.gz"
  sha256 "8aa3dcb1b50418cc9cee9bee86bb4b279c1c5a34b7adc846697205057d4826f0"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86605c88a291edff807e0cdefaf09421c1ad00f9a292393ecaa2035173f13ef5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86605c88a291edff807e0cdefaf09421c1ad00f9a292393ecaa2035173f13ef5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d2048c8edb96fe0dd49b8cd52aa1139f63fb275523022cd2c4e7a6ab45a496a"
    sha256 cellar: :any_skip_relocation, ventura:        "9ccd093a0733d354b484b5fb5245315c8507c512a0f96dc51d90d36c09779d34"
    sha256 cellar: :any_skip_relocation, monterey:       "86605c88a291edff807e0cdefaf09421c1ad00f9a292393ecaa2035173f13ef5"
    sha256 cellar: :any_skip_relocation, big_sur:        "9975ca2bcb400d61bb8a456c951d9a069cff60f90efa440f211916fbc32bb5b0"
    sha256 cellar: :any_skip_relocation, catalina:       "dd32d79091815434db1c465b3f7caa6c6c346449558d82023a6d88ff92c6ba6b"
    sha256 cellar: :any_skip_relocation, mojave:         "0a6c3ead2d8834fb3e728c06bb72d1102ff516cfafd8283e96b03c5a13a44b89"
    sha256 cellar: :any_skip_relocation, high_sierra:    "53cbfbd7d9f86fa6ee98b46356d76db4c952adbf9e3cf913f0a3136da56bcb69"
    sha256 cellar: :any_skip_relocation, sierra:         "3ccd021a4393d137eed5c0dfdfe94b325b6142258a7090ad04f9166039efa52d"
    sha256 cellar: :any_skip_relocation, el_capitan:     "e556bf6f7ddfa3e9f6a9b726d80a35404270c96e36ada122fd16d8946394aaa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0241293740ef38cd9f22206e021d3a7ef2be7cdb505320ca904b728c321ee80"
  end

  uses_from_macos "perl"

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/gits --version")
    assert_match "gits version #{version}", output
  end
end
