class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://gentoo.com/di/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-4.54.0.1.tar.gz"
  sha256 "b401e647ecc3c8a697651bd29ad1cc6ae319f69a248b4dc4d3af0742f64b4ffb"
  license "Zlib"

  livecheck do
    url :stable
    regex(%r{url=.*?/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5366283a2233265aeec1d630e627b8fa9d4db9811b0ef34d5b8a051e8fe0163"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c939223c1ec05541c4b9ca28a3e387cd4c5df4687c243f54a22e206f6ec3e1a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a3a377fd49be3eb9d5bfdc16ca4a7b66dc5b1cb64bef27ab88bff581e010e56"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fc90ffa73aa063421977eeafe04c3b2c0a9319fcbdc80c90decef338da935c1"
    sha256 cellar: :any_skip_relocation, ventura:       "b41d6c79939170ffa37d2ca760e085024988832e82c15a84f38bec5950738ff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d3898fd49a626edd4b27777a5b5f9a58c2e9f65fd4939eed0a3e47d0ee6a361"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/di --version")
    system bin/"di"
  end
end
