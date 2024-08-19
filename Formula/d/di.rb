class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://gentoo.com/di/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-4.53.tar.gz"
  sha256 "00dd5befc11dac8d65a68b248fd34158a2e6a850c2e4e2ab77594c79aa01e83e"
  license "Zlib"

  livecheck do
    url :stable
    regex(%r{url=.*?/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1cb85ef2ac8d49ae838f9dd1532429f21d3542ddbdc4afcb2fc0b16e8ac150c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "471a2eda35ef12e75e26d879eb314db261dc04991678281798a56f9054af0bac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ff4f6e79db0371824b4a38d86529199a3133781e48df12d5b1d79e6b51f0dc5"
    sha256 cellar: :any_skip_relocation, sonoma:         "809d81076eddeb2f405b12c0639fa56787aa15b8d7c4ac170991298fc431a1b9"
    sha256 cellar: :any_skip_relocation, ventura:        "4bafb5d2d243a519eb48c23c9d319b50e88f6e7f6883f8da628a8000f9581cbb"
    sha256 cellar: :any_skip_relocation, monterey:       "863bef6679888f9a1d44dde5e771953bc285a06baf3acc2ed05ea088313e2723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31a51f410bed3067152b6f8b6c23948e5f98398a774f183c987eaba0b4b27c20"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/di --version")
    system bin/"di"
  end
end
