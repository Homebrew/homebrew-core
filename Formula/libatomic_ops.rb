class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/ivmai/libatomic_ops/"
  url "https://github.com/ivmai/libatomic_ops/releases/download/v7.6.12/libatomic_ops-7.6.12.tar.gz"
  sha256 "f0ab566e25fce08b560e1feab6a3db01db4a38e5bc687804334ef3920c549f3e"
  license "GPL-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b1c3b5131abdae9c2df1e915a9128c6e892fe05a5975d5ef2dd2c5c56d946b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51e94ad755b4f85d03f3ac3d67a089f7fa0588340682838fce8b3ca5de193e81"
    sha256 cellar: :any_skip_relocation, monterey:       "89a4f8f01bd7c3991eabbdb321dff7395cff0765f600e59dea1ccc6bf95906e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "017fae77e5ec0d547f9e8fb08cf907af0fbfabd6eeda54d4353a446e37371971"
    sha256 cellar: :any_skip_relocation, catalina:       "c9e0de613f4d3dbd8f0aa005c5ed038d8054ed87f8d9e27d10d182113227c923"
    sha256 cellar: :any_skip_relocation, mojave:         "40c602dbee95c6e67b3c0b63f32a3e4ed81e6281941a1cf484fc8a95394f8f1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e88da0d1511648aae7d26e80745f9a85884ba0a347733ebdbe6cc043eb6708cc"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
