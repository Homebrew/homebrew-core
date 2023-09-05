class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "d979355a7dbd858c9188cd2cb7d90b931e3a73d471cdb1abacc7468565888dd6"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f65ae0a7fd8aaa72581cf9302d15dce16a41638864d96933de0ef5be1920a59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "554067cb1ad250110b9653c1891b2053cfcab3ef690db32e708943cde953e99f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "622129f42793e50c3f29683671eca1bf30477947cb2895f929f2db0ab79c0dc9"
    sha256 cellar: :any_skip_relocation, ventura:        "5a477b1eaa95f885d932186997a0d6017411dc4575be0de1441deab6257e6a77"
    sha256 cellar: :any_skip_relocation, monterey:       "54dc92a6616473afc71fcd0d51fd8a98258b9f7c082b95782430eaa15cac91ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "0994894d64caa5cc751642172a5640e1688f6a42c3ae82080b6aa8ab491c9857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d17d3ad528b0b8bd3836fecaac8ea87d122fb7f4a88e9b47819eb3d1ce59eba"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 200 responses"
    assert_match output.to_s, shell_output("#{bin}/oha --no-tui https://www.google.com")
  end
end
