class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.13.3.tar.gz"
  sha256 "652779f7199f5524e2df1747de0e373d8b9f1d1206df25b2e551cd0ad33f8440"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94f5e714323c310678e2f339b24675f7c03a8f7e96d3179dcab121adc9d6ad74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5abfdcbcfe2fcd98f1416548c69b2255ea1264f6236d2d9176382be42b4216e"
    sha256 cellar: :any_skip_relocation, monterey:       "d9daad4c54da1a2902eb19cc58096e4e8c06a98a52bbeb2faf1571af56cd0bb9"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2104d3eab80d8bd12f0c0defeebd7592d1ccfb5d8040e2a517662dff2a5b03e"
    sha256 cellar: :any_skip_relocation, catalina:       "88fd292078fad4415ea77ab095f69fc31a23ec61b44ffa0d0ceaac159a08d4db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62f490795c478eba8f485de1f56ae378b2988b329897af911206d1589190d369"
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
