class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.11.0.tar.gz"
  sha256 "80b02a8973d2a0becacf577f15b202273002ad9c4d9ef55d8910c8d433c99a59"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed5f1be4059b41113c35f0a3ae1f01ae5042b143869d22457428507c4a976812" => :catalina
    sha256 "8f1dea3bdea9a75644f0a3459d9ed61c391e5e72886f734e8c4dfe0465a94903" => :mojave
    sha256 "c2e6978c73f4bc53891a7d42aad74a679d6df421caeb595550dfd3193929d7ed" => :high_sierra
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
