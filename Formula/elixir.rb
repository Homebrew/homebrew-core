class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.12.1.tar.gz"
  sha256 "96167d614b9c483efc54bd7898c3eea4768569a77dd8892ada85d7800d5e3ea4"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a4076024319aaa559386b60b2c114d89ac327552a16dd63151c517dacd09fae8"
    sha256 cellar: :any_skip_relocation, big_sur:       "aea92e79f010ded4ab036a442fece1d04c89f55143ade4253b1a72d1e0d963f4"
    sha256 cellar: :any_skip_relocation, catalina:      "c12b1e73a30867954d87a4714007f9fe402884342e3e752dab1df28a98b31bcf"
    sha256 cellar: :any_skip_relocation, mojave:        "829d1cc6b9ba8fc2b8037bed900b1fe074f08a40f52f58e9c0cc10dbb4afbe4f"
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
