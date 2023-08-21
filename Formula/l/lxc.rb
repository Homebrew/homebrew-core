class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://ubuntu.com/lxd"
  url "https://github.com/canonical/lxd/releases/download/lxd-5.16/lxd-5.16.tar.gz"
  sha256 "7afb4d3d9be7c7caf3affb49904a7413b06150158705225d32d649424dd5648f"
  license "Apache-2.0"
  head "https://github.com/canonical/lxd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41f0027ffceb1d75d337166141910a6058bbb60cef1ccd5c1c513b42308ea242"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41f0027ffceb1d75d337166141910a6058bbb60cef1ccd5c1c513b42308ea242"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41f0027ffceb1d75d337166141910a6058bbb60cef1ccd5c1c513b42308ea242"
    sha256 cellar: :any_skip_relocation, ventura:        "54984e0c5a22ac9c3c17a38937e4e96de8204bfbaa650d91fef3e19e39d70618"
    sha256 cellar: :any_skip_relocation, monterey:       "54984e0c5a22ac9c3c17a38937e4e96de8204bfbaa650d91fef3e19e39d70618"
    sha256 cellar: :any_skip_relocation, big_sur:        "54984e0c5a22ac9c3c17a38937e4e96de8204bfbaa650d91fef3e19e39d70618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f7cc3a4506549ac36748d036c3a985918438c02d8aa126c335eeb29a77aa6f8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./lxc"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/lxc --version")
  end
end
