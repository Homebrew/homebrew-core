class Certstrap < Formula
  desc "Tools to bootstrap CAs, certificate requests, and signed certificates"
  homepage "https://github.com/square/certstrap"
  url "https://github.com/square/certstrap/archive/v1.2.0.tar.gz"
  sha256 "0eebcc515ca1a3e945d0460386829c0cdd61e67c536ec858baa07986cb5e64f8"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44595ed41984a89259ce447959ea154a4506e5109038c649b46ebdf5d8556ec3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95290ccc53030ee471239996d914839d094f19078edcf7dbeef742730d46b64c"
    sha256 cellar: :any_skip_relocation, monterey:       "3c4dbf08de58f473efe0062ccdc5d0cbd51bf048656f14d5f042a9bdaae937e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "44b1d5f60f4dccbe495c53006a828784dcacca1f63dd008ec93d8a502ed8fb46"
    sha256 cellar: :any_skip_relocation, catalina:       "52e68d4bcd2256bb1026aafefc9aef39c0e7945e1f26c06b3e09f3b7e7d9ab14"
    sha256 cellar: :any_skip_relocation, mojave:         "8f7fb0f6d8b559ee4d30972a68d5d76117a86c07233abc49237c516f45f07277"
    sha256 cellar: :any_skip_relocation, high_sierra:    "12fdf1f518c3f2944d30f4289813a82aa56580b844fc2cc1ad3383d8675c9882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13724be9c67b61927d775d2e0eadd328a7b9c10922cd0660d5a0d002c4c8ead8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o", bin/"certstrap"
    prefix.install_metafiles
  end

  test do
    system "#{bin}/certstrap", "init", "--common-name", "Homebrew Test CA", "--passphrase", "beerformyhorses"
  end
end
