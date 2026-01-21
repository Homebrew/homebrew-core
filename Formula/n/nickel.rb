class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://nickel-lang.org/"
  url "https://github.com/tweag/nickel/archive/refs/tags/1.15.1.tar.gz"
  sha256 "93528c7b763f082767f4f6069b74f72345880ee6f5175f85ea8297d96d8797c3"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51ccba856b0d190c9fb33466601c203c07e832ba30b163a624a9a35a2745ec6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6f9b06817e7d2cc8a867cca8e88ce2f7a46817cfb63c53d7bdc0807de6f25d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7b29ce1a0fb84e930bb9d02266e882e478bd3c11a647b422094bb135060c8f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c999ddbefa3ea6f1f1bca32e2a16ce0c3af1f7a44fc8f01fb6944d832bae7c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c96c9c3f7ba926a035e7efae8b2f683426f5fdcbc14a7478692e136dd61ae6ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a996fc6d499249c6ea130cc5c9c72d5b39111c9c13d6cef60386dfe6334381b"
  end

  depends_on "rust" => :build

  def install
    ENV["NICKEL_NIX_BUILD_REV"] = tap.user.to_s

    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"nickel", "gen-completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nickel --version")

    (testpath/"program.ncl").write <<~NICKEL
      let s = "world" in "Hello, " ++ s
    NICKEL

    output = shell_output("#{bin}/nickel eval program.ncl")
    assert_match "Hello, world", output
  end
end
