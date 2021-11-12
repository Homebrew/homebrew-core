class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v5.0.4.tar.gz"
  sha256 "3976f7d87bf285f1dcb2db1730489fafd2c9b586ad7002a5bf9032496bc8534f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b3983b0a5cee44b87c02d84de1a10b6fd4673bfb3ce06feaa4a4f4a12596c82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9d8386545ae5c433eccc2b543a98536070c06be198366b276239838a28833f0"
    sha256 cellar: :any_skip_relocation, monterey:       "42e593494ec3a8cbbe98277a5d117844ace4bfa3746bb11c41767748be945a98"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a5ed294fcc7d1a079d96507e49947a570150aeccb293406764ad3c1ef7dfaa4"
    sha256 cellar: :any_skip_relocation, catalina:       "0bd95dd047a1e7ace35bf936338c38c469b41bbb9c2df709917cfc1fae40d520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1068511ac8980aeefb8e32080b76fb8e72d9caebe8ae7145b13592deea91bd7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
