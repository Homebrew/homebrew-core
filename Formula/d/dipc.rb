class Dipc < Formula
  desc "Convert your favorite images/wallpapers with your favorite color palettes/themes"
  homepage "https://github.com/doprz/dipc"
  url "https://github.com/doprz/dipc/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "3cc4e46cb6531b4b903d2c1a209c19667acac34d91caff5967600ed51c4bebc0"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d52b47ebc1d3d20a2e250c465ac049a73fcf6656a28950be303c3d01eea1e5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "497816e52f824984125a054da99497221a2e9509c352cf96850a0b1bfc8fc808"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9573c7ce3a5959ee64419e0f4d86f53e16fd3f4202ec779b58a7ce5cab0c8b6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "03b62b264e757322dd4d3b023bf6c5976e6b040ad463ba0b7bb692821bd8e282"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7a4f18d9c4334c7135584da6b98b09b993d53d01fc8d742dcf10f684d332d93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0899ffeb4c35b37649259dc109f04d59ff709e58436bcc7e846bde5fc519a2cf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test processing with a built-in theme (gruvbox)
    output_path = testpath/"output.png"
    system bin/"dipc", "gruvbox", "--styles", "Dark mode", "-o", output_path, test_fixtures("test.png")

    assert_path_exists output_path
    assert_operator output_path.size, :>, 0

    assert_match version.to_s, shell_output("#{bin}/dipc --version")
  end
end
