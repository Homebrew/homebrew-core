class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.14.0.tar.gz"
  sha256 "134ba69744705bdb65ea57e25713300a6771f7cecbd5d6a74dd9472c18ac2696"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?dnsperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "c12ce321fce2e77c1a9081a50cf8887e47f4474e51d69475e7364b253caf4eb1"
    sha256 cellar: :any,                 arm64_sequoia:  "105e91000e93fa837ba43661cac925cbfab0bfdc679fa7e9920c590c0f0269f3"
    sha256 cellar: :any,                 arm64_sonoma:   "1f56f85a5973c690c2d511f197d2af107391cb2d73fc165a10b2bc604095b7b6"
    sha256 cellar: :any,                 arm64_ventura:  "0c6940568620597ca23ab89c37dbd3cafa038e4491020c020a491ef852b07bee"
    sha256 cellar: :any,                 arm64_monterey: "7b523397aaeb7d710a9310cec381eadc01b32b0d19bf9f50bd9813d14c1f6bb8"
    sha256 cellar: :any,                 sonoma:         "4b575d306d9cb921ac4f1dd85fcb0d565e4544ea9a2e9215dac68725f6a0e630"
    sha256 cellar: :any,                 ventura:        "b9f8c954172caadcfe59c81730f835290a6a8327c5f4e4785c353f839cf5cef1"
    sha256 cellar: :any,                 monterey:       "fb4ebe4a3f3149b67cfd098d51b04db2fe8bd3bf88e827bb9c97d266ee150300"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d10da227a6151f14a8d411e714a5d3ff8fabc3ed720c067f6a569ae215e8a2d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20a13780c6a708fea6bc212705ba13d38756d63a487f908637bb159651f5c070"
  end

  depends_on "pkgconf" => :build
  depends_on "concurrencykit"
  depends_on "ldns"
  depends_on "libnghttp2"
  depends_on "openssl@3"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"dnsperf", "-h"
    system bin/"resperf", "-h"
  end
end
