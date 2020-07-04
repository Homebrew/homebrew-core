class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.10.4.tar.gz"
  sha256 "8518c78f43fe36315dbe0d623823c2c1b7a025c114f3f4adbb48e04ef63f1d9f"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d02f86bae935461933e8dbde1052e954351d6adb39575df31b974ba97c5cb98c" => :catalina
    sha256 "267c46f18891050670a9c0872f155a646394ae311bf87491681540004dbba0ea" => :mojave
    sha256 "0d3ef8c94f9def9cb7dba9236ca215a0a6b0da34974393b771015c83bb81aed0" => :high_sierra
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
