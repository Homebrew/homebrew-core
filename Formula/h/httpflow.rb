class Httpflow < Formula
  desc "Packet capture and analysis utility similar to tcpdump for HTTP"
  homepage "https://github.com/six-ddc/httpflow"
  url "https://github.com/six-ddc/httpflow/archive/refs/tags/0.0.9.tar.gz"
  sha256 "2347bd416641e165669bf1362107499d0bc4524ed9bfbb273ccd3b3dd411e89c"
  license "MIT"
  head "https://github.com/six-ddc/httpflow.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "6e9299b293094af5b4947a5d1ebdd4ff98c6f56b5d1e148b0b3df61a5cda63c5"
    sha256 cellar: :any,                 arm64_sequoia: "7579060ce00a8d1c70203cc1670139f45d92f7d22ea820b61c5fd7aa3c2828a6"
    sha256 cellar: :any,                 arm64_sonoma:  "970e799b29e6a5f403cd4ec79a92de569d05779ace7c25afe1819c7161339eab"
    sha256 cellar: :any,                 sonoma:        "45e3e0a5357cd5f6d907677653afcdbcb828faae3731705f0f6acdb16eb69d81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "011031ee7faf0f0e86f2628d1e60307189def32af966b42f977f2c2762c626dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "600ed0d8a1171c7d99c6c53579b72b6f3ef809705e5e9c9f1cfc8ffae39a1ffc"
  end

  # Last release on 2020-05-07 and needs EOL `pcre` (https://github.com/six-ddc/httpflow/issues/12)
  deprecate! date: "2026-01-10", because: :unmaintained
  disable! date: "2027-01-10", because: :unmaintained

  depends_on "pcre"

  uses_from_macos "libpcap"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}", "CXX=#{ENV.cxx}"
  end

  test do
    system bin/"httpflow", "-h"
  end
end
