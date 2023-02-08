class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/v4.9.1.tar.gz"
  sha256 "da5b71c0f7ba35c724dd329053c9e879893806904a8ce36299ad8465340ac5ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70de659e13ab860d34d5b2303703c78677df5d6b9e4dd1d6f528617fd918d502"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a79f2c649d60f9468231f8f2cb7bcca3c59bc02bebf56854e1ae457787e3a09d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bba9b863e99d8e8590c25758b32a28d756df1ce276185f89ed7cf75d7d2d121"
    sha256 cellar: :any_skip_relocation, ventura:        "bab07cf5b274e5f69771f5a2482bf6c1240a79e5e3da2347c6438e564f838b9f"
    sha256 cellar: :any_skip_relocation, monterey:       "a8461e5e6c8a3566c69cdfa3b7838a6cc0f0bc4803fbf1099212d2f99586ef02"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7147fa1db85f1d76cb8776bae970138d7362cc29c87020eeab6713c6cf86744"
    sha256 cellar: :any_skip_relocation, catalina:       "c13740a0cf471274a601007daf4027e8fd7944e7257e1fc83ee1d5412523a4c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f5a3b085d4fe731ebc45e0feda6e3c9a18429529161586b2392f1e357937fdc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/lego"
  end

  test do
    output = shell_output("#{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1
    )
    assert_match "Could not obtain certificates", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
