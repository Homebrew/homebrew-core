class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v6.0.5.tar.gz"
  sha256 "88de2c9718e071dcd9486cf1e7d87d46533100e589d99cd7b18ff43c21a8a053"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1226779f8c985dd3debcc6c6f35f56f809e983d3b20c15621edacfb0b5bcdc9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4432d48f009b0f2bc3deac933181f6704f350947bf0926b943c755daeb2e99e0"
    sha256 cellar: :any_skip_relocation, monterey:       "cfd70d9307483c7ecb91cc280c17a53a544248d9300501e537238eaf120a6f3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0200b8cc71221bf52a94a74f9b5ec69a64ac4edc0d44fab31594ff26e0803d1"
    sha256 cellar: :any_skip_relocation, catalina:       "493afdd371ed29572c31a699be770a466cbbf06072fad661ceba50ccad0908b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "600709dac217457a71f5110db3f286e0329a324aa20e12374716d04ef2466955"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
