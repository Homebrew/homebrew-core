class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://github.com/Findomain/Findomain/archive/8.2.1.tar.gz"
  sha256 "93c580c9773e991e1073b9b597bb7ccf77f54cebfb9761e4b1180ff97fb15bf6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0854489c161c180f00e4c8d551bcc06339db0c77e4fc37fbf9ba64b3457f478e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d8da7e51087b7c2d3319d514e82961802f000ac59e01d52e729dc95c2f59b17"
    sha256 cellar: :any_skip_relocation, monterey:       "b162fe9c6dfe0f2eb152051fa409389b26e38a80ca41ebf72910d0796b1baf37"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b825017ebd6d1fcfb69041228342e44aad0b56b93c507fe93072169c4ff8d24"
    sha256 cellar: :any_skip_relocation, catalina:       "a6555b06978c1566e486c24106b79982fdea0006f21708646ffc5516eb9330af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5c5083e92b079524ba537ceb7542937890af5f2e321528083e44549c1a28e7c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
