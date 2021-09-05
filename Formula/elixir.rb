class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.12.3.tar.gz"
  sha256 "c5affa97defafa1fd89c81656464d61da8f76ccfec2ea80c8a528decd5cb04ad"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9931199e37b5ed93b73b10cbbea910f735d537d935f7e0609645e828d5883a0b"
    sha256 cellar: :any_skip_relocation, big_sur:       "4911491569ca202ea71fb36a4bbb50bc89ddb936148660f0c8a484e4f0b84052"
    sha256 cellar: :any_skip_relocation, catalina:      "e362b53d078cbbb93b016f5e0efe53347e2c2b18c44419dc80070570c4ac11c7"
    sha256 cellar: :any_skip_relocation, mojave:        "00b036d03064ef97c3cdca45577a412e22304f19b357d1906098161ab7da9450"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b326bd62c565a30235d99c47986c8d12ee22a453a5a7863c46f586f805457438"
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
    system "#{bin}/elixir", "-v"
  end
end
