class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v7.0.1.tar.gz"
  sha256 "33d210287c7a3752135560f743cdc2d944048986f757c3ac1db6e738e01b7ebf"
  license "MIT"
  head "https://github.com/tj/n.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "67abc6b90563433086f1ee8579175828270501c6247497254aab6aba52665429"
    sha256 cellar: :any_skip_relocation, big_sur:       "9acfff0beb0b3f16c4d5ce59aeec0d62d69020f9dd2dc3457f65fd56be640e60"
    sha256 cellar: :any_skip_relocation, catalina:      "f21d5d3400bf1675f9b361491a7cc33d2edf779836f2e7d99454e0e8cc185c18"
    sha256 cellar: :any_skip_relocation, mojave:        "371646873ae44abe06dfe6637cac561b10c490be8326e6d77006da52cf50c54b"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
