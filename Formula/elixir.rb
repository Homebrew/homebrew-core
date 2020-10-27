class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.11.1.tar.gz"
  sha256 "724774eb685b476a42c838ac8247787439913667fe023d2f1ed9c933d08dc57c"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b86858e6a9f652c10827f96ea5015fe8d02b130e2cc3ea03e5704b2bb6a09bd0" => :catalina
    sha256 "5b8b0631bf0205290ee3b969bb4562919256006b18102ffceb3b3829e68db010" => :mojave
    sha256 "072381ac0a025e0e75ac0d122c4ecd92daec4508c523d23a5a43143436c4e01f" => :high_sierra
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
