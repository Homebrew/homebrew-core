class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.15.2.tar.gz"
  sha256 "3cfadca57c3092ccbd3ec3f17e5eab529bbd2946f50e4941a903c55c39e3c5f5"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b898dcf22ef5c399241aa9c046f65fc1dca7cc1b2d58b548d4029c9c5ed8c792"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fbc147f5ef64b01df16e7edd246c80297669aa3b699fd1da55202ab20373058"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf24934689d10ab17964b12ef69ad8c4130473aad9994a4d96b1b6fca3294fd5"
    sha256 cellar: :any_skip_relocation, ventura:        "0d4dd919b85f1a5bc73896a903167c5cce2242eef67d23f215341d44654879dd"
    sha256 cellar: :any_skip_relocation, monterey:       "a702be0f0e5a6edea97203305cd5b0362fc5cf3a174fb6e58f330fa366a8ab8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f2f0d6e620ba18fdb498d774e84f1e13f682502f9ab493dd589030a3e4ebc67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6e830372f71512b10f18b114859ac2c1745ce7a168d78ace91a3dd7422206f8"
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
    assert_match(%r{(compiled with Erlang/OTP 26)}, shell_output("#{bin}/elixir -v"))
  end
end
