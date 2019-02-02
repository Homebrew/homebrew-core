class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.8.1.tar.gz"
  sha256 "de8c636ea999392496ccd9a204ccccbc8cb7f417d948fd12692cda2bd02d9822"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "500c7eaf16cd95da4ee4fc34bdd24ef79c9b9977e2b207a50ce6b155433b4b00" => :mojave
    sha256 "5b5631a49467e4c1e571892439e55528a819b692700106bd88982734491bb389" => :high_sierra
    sha256 "313682784edc7959a339ca8b08bd0e2c3975978e6e80d0c2fd737b5be67b7e82" => :sierra
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
