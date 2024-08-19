class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/refs/tags/v1.17.2.tar.gz"
  sha256 "7bb8e6414b77c1707f39f620a2ad54f68d64846d663ec78069536854247fb1ab"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "424318d1e358738bae6b7962592be58a3254172872a6d78640a97e45ac475ae7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5aea5e80878f7ea14ed3fd534bf26a0c2bf3fffac5323c0bf349d7ccffb21999"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bddc5525f797de8a69a156eea21111499d2ea0da39ae70ea8c3ecbacb6515ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2725b97ebda4e2d34277c129cd173d244de4ece061e12dc31f9abf952c7dca5"
    sha256 cellar: :any_skip_relocation, ventura:        "75dec7062894feb5ef0ea2c1002bec5609b387afe302146a651e0fccf1b644f5"
    sha256 cellar: :any_skip_relocation, monterey:       "84ee927110ebe3741751680cfc9c060919ecb6479973a0c05f9dcd9d141f926d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d380aa5f17083f3a8493e6f0991e2738773bee44badab0bfb39d18033307de4"
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
