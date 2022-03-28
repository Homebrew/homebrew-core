class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/v1.6.0.tar.gz"
  sha256 "b8b0802171db772ee98aba8ab6e916f7c77f450041fc78b0557e851dc45ca9e4"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "792d20c321dc42f993df8c7a7cce256c8567dd485ede770f77f856ad059cddb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2571fbb3b35e90f43f4ea88a498a004a385b44342ec2e3cc814b49c07cc6d74"
    sha256 cellar: :any_skip_relocation, monterey:       "80d7ee0022be255120947f4669a978a7e1866471c502c4e55411089526048f45"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec5cdcb31a403759aab3a95e95be416e1a3af8a40984bc131cb31ba6625b13a2"
    sha256 cellar: :any_skip_relocation, catalina:       "ed479977311f6b5acc29a2b604b6c8a13e78a2ddf68d9da7d827bb2dfd062a06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9ebab897b716371910cc78ed935efcba32dbd7376ff811ea038ac1d9671834e"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end
