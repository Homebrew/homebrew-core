class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.14.2.tar.gz"
  sha256 "3f79e384706495725119f60982fa16ea82d510c3fbeacfc6ee1a77c792bf152a"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d5846e972c092c16e91b58b8b0ad58b34519021d946451543dea9121440fa71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bba230b8f383dc8bc896ffc1d9c61d8c574a54289f1b68f7ec7160c20a75063a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f4e2e610011dc4343595fbb5c905664470ca2aa2e4a8b4dc7df2eecde49ad20"
    sha256 cellar: :any_skip_relocation, ventura:        "a562173ee5f2b201f5b12181716609c4b8f85435c4d1f0497a273e28ac690e97"
    sha256 cellar: :any_skip_relocation, monterey:       "073d89fba1c8d633cfedd6f482ad1098e1acbc6d9d1f6eaa4adfcf3221dc3824"
    sha256 cellar: :any_skip_relocation, big_sur:        "792186e3168e3dc51e336401290916ae45b48c78c2e7ac76bfda55fbd035aeb1"
    sha256 cellar: :any_skip_relocation, catalina:       "0496616c1d69c9e3a0434f9208bbbad24bc2cb8aaa17dd8b8909fd35e487165f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53e217f98eb4d875d5977dd794db8e8941e5257e7b495c0a8571623faa4bfc33"
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
