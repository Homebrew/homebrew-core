class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v5.0.1.tar.gz"
  sha256 "aff72d2f627617f3f36d9796e65b83eb34f24d2c94f3a55612ade2df8ab8d946"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a32fab646529193e75f326b59cc307fd377b1fa04b6270b8c5d31ad99c98baae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57c588a6da76b0f39b34c4893e6255e5e9c801bab80b08d1b3e67b82f4eae016"
    sha256 cellar: :any_skip_relocation, monterey:       "4f61c7f9d8c0c90e35e902c8ba93164c44dca460c19eafa373a09a59c97c7ea5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7c8e1dea8fe8616af0296f0b85dc2095afbdb8b4814e447e8a98c7d73a0f4d9"
    sha256 cellar: :any_skip_relocation, catalina:       "2ae698cc8c75faeb6f714561a1914cb4728bbe8567a2e2d3b963ac23c6e9eb85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98e09be140e16bbe52173dc7e00f6d05e5bbead3ae4d274c9d128b7063963bd2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"oxipng", "--pretend", test_fixtures("test.png")
  end
end
