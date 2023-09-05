class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "966e6cc68265548e9f48d3c51943141d0d82af17409786b2900d65e19fe6622b"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "409d241308e3da1a85d5be1c4674d50c0f7d719c635cce75550df2492141af3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e65615308513be941a61af61060b7a8d5795012cffa0450f99a0b016799d3ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80387a91df1f527adebb5808c831870e8d61e683f1027051951c7ad7afa901c2"
    sha256 cellar: :any_skip_relocation, ventura:        "8822165550a624ce825e19285a5f2ba1ade8f393242c1fe1ec2f20ad30363238"
    sha256 cellar: :any_skip_relocation, monterey:       "cf5cb8b7ca0126d4c3c88ac554223ba71815ee5173e297b6e18be062f9afce6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "65600475b45a02066ac1eae114ce433abad23487eaa975f25067f8ba654d503d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2be4606c7cc87313399487ae5eba6332ee985c8b603adeb3fca4b4215135cab6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end
