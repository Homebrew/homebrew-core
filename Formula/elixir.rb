class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.11.1.tar.gz"
  sha256 "724774eb685b476a42c838ac8247787439913667fe023d2f1ed9c933d08dc57c"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9060efe48a87d9ff9411db0b49d82bd0f77a8ff4cf8c8152dfc1e4fcc513f00d" => :catalina
    sha256 "978c9d4dafc6c05136f763038ad36a8c21933b363b29c1dbc93936a9b4d67097" => :mojave
    sha256 "57b2c8ae4d22c053f3d28e2e66153d30961dc1dc5531389fda64925189c41e2a" => :high_sierra
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
