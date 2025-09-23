class Havn < Formula
  desc "Fast configurable port scanner with reasonable defaults"
  homepage "https://github.com/mrjackwills/havn"
  url "https://github.com/mrjackwills/havn/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "8bb9d57dc6868006b5339e93b2498806d72e44165e3a2221b3596ee04c99d61b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "846309b774534e4f7cfe5519022e9723436a7a1fd85d6e1b21fd504dd0e210bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1ec70677f0b940a9303db4bcf2ac704ab2642725dee26c13ba1c13c26409538"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd0181ea88783bb330d16c4aa7bbda9f67145683153f9965738429192daf813e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7426998bd5218abb119dc0c57fbbcdf0ae62548d0a65df7cbdce6d71120aa0e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "efe40b1252e06c5954d905893c2194c63976854cbb265f4d501f6639f3aee213"
    sha256 cellar: :any_skip_relocation, ventura:       "2402459df8ca79868b9758c3f4ada1610c774cccbaf36b9c0ba156cbdd467651"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b807decb761e4a2d223b9b6a0074b0a53ea2e6f93432dbe08465343c0e50f5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29da54cec396a0d853d3242a00c8a6179868146862eeb250ce24b5c279e53bf0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/havn example.com -p 443 -r 6")
    assert_match "1 open\e[0m, \e[31m0 closed", output

    assert_match version.to_s, shell_output("#{bin}/havn --version")
  end
end
