class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.14.5.tar.gz"
  sha256 "2ea249566c67e57f8365ecdcd0efd9b6c375f57609b3ac2de326488ac37c8ebd"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92e5c80ecf93fc98978ca12ca8c972ee4c179825c4ef62788b9f4d76ec1e964e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2a429e4ed264dbaf356c5e6de5fbc1d82e7c763c58f0a0f889eb596f1c97f44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05134af4decf6a44c3ef10d3a4fae899920b662e46e90dde8b53c2515fd8665c"
    sha256 cellar: :any_skip_relocation, ventura:        "fa3bcd8bf07aea1e5c66cb1fe4f6e1bfc24543dbfd14c7ad52d03d2582a958c9"
    sha256 cellar: :any_skip_relocation, monterey:       "5974672ec33ec16102f85c3f8595405cb8e22a084dbb9b3dd6c2cb10bbf1fe64"
    sha256 cellar: :any_skip_relocation, big_sur:        "878eb21c02da54ff1cdd1e913c391ff4fb6689dfb1ce6b0a1253de23a40f4dd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee0f60e888cf726d9693472c775378fdbd65eadb8ff3ad7407d6ece3e50b587b"
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
    assert_match(%r{(compiled with Erlang/OTP 25)}, shell_output("#{bin}/elixir -v"))
  end
end
