class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.14.4.tar.gz"
  sha256 "07d66cf147acadc21bd1679f486efd6f8d64a73856ecc83c71b5e903081b45d2"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40dc3f5e01f14437caf4366cf3029e419222038486428d791fcecbbdac3da77d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "528c71dd070f430dbb750b7ad4a66eb2c193c8a2733e0d9e7b66edf11ea33f5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4958ebbe50e7cf22afbd54cf28d0f80d16cabf9c6301ff3fa580976e9e768aff"
    sha256 cellar: :any_skip_relocation, ventura:        "d62d189a48ef6b3fcce80e46b9201f840e3d022af8df34663995cac9b7016d2f"
    sha256 cellar: :any_skip_relocation, monterey:       "bdcc3ce891d77fd7d4a90c68d34f922aa29f52da701671061c78856100b8dd1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "4557eb175b45bb45fe081c17f1fd3c017bcdafe66c34f30e1b16a99e560ccb30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31eaed5d6d5eb55c7c880c7bf15c02d791f1a433f4fabd69020eb736bc9d76ca"
  end

  depends_on "erlang"

  def install
    system "make"
    bin.install Dir["bin/*"] - Dir["bin/*.{bat,ps1}"]

    Dir.glob("lib/*/ebin") do |path|
      app = File.basename(File.dirname(path))
      (lib/app).install path
    end

    system "make", "install_man", "PREFIX=#{prefix}"
  end

  test do
    assert_match(%r{(compiled with Erlang/OTP 25)}, shell_output("#{bin}/elixir -v"))
  end
end
