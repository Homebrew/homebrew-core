class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.12.0.tar.gz"
  sha256 "2fc896b5f7174708b9a643f1ff3d1718dcc5d2ee31f01b455c0570e8424a3c9a"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "153ae385be17ae5884a240671d1751dd27aa3972461f6224d726383b60f59e25"
    sha256 cellar: :any_skip_relocation, big_sur:       "74bfd7543233a3ea0b1524fa1423410f33bac4e8ee7252508f1cb263037d5672"
    sha256 cellar: :any_skip_relocation, catalina:      "5c4163b77a321f6808c9a1014c136cc93159158340643ceda82658374d92a0d9"
    sha256 cellar: :any_skip_relocation, mojave:        "c79b9f898eac5d4af4059ef72f806a76989d373780630a7652f7512de115f245"
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
