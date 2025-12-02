class IntelliShell < Formula
  desc "Like IntelliSense, but for shells"
  homepage "https://lasantosr.github.io/intelli-shell/"
  url "https://github.com/lasantosr/intelli-shell/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "041dc22be0928626fb0562d7bc859490a4e0e6bb9c32ddbe1cdfad08f39623d8"
  license "Apache-2.0"
  head "https://github.com/lasantosr/intelli-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "40e6b5b79d074d6fc3d2af0db31ecd5a499835402439f3222659eab86422492d"
    sha256 cellar: :any,                 arm64_sequoia: "c84ad3d3ef3ad543f4cf61b5feebbae780f105bab408ef1bbd814fda49927315"
    sha256 cellar: :any,                 arm64_sonoma:  "1e6ec12a1e63c9e79757c09d9bde9e0094be059491b2df5b3750fd621e6ba31a"
    sha256 cellar: :any,                 sonoma:        "1fab7b9946ed3d1473d86025a075903370e98af07803a1da89bbe8dbbfa03d65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2eba1cae4caae6ac000a0e8bdec810058a228e84b47ece650686fe0fa97a7c09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8087a9fc93157572e14c27674b89c30b7fbb1695c4498fc2c0c967cbb8d13bee"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/intelli-shell --version")

    system bin/"intelli-shell", "config", "--path"

    output = shell_output("#{bin}/intelli-shell export 2>&1", 1)
    assert_match "[Error] No commands or completions to export", output
  end
end
