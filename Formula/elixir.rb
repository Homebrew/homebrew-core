class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.14.1.tar.gz"
  sha256 "8ad537eb84471c24c3e6984c37884f06a7834ff2efd72c436c222baee8df9a11"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf340a0f6b1eb60d351908238eef2a4d4efd4a46a9dd0b8ada3307acdf2349e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdb3dd124b76b8c053824c7100267c8e5e13ad28dd01896fca29b970b690e8e8"
    sha256 cellar: :any_skip_relocation, monterey:       "ce4cc802298ed70ff11b67bd3ea66f7ca31c5622deb32759a667eaf418c2dce7"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4cd28f9a2d4a78f36f47aa40034c73cd71f34841840627343d8632fe68fc14d"
    sha256 cellar: :any_skip_relocation, catalina:       "c38165840752d0ddebc3f637b1f9a738e52003d2539e03c088fd2de658939ba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20657ede4c7fc987bb381e5ede14fbc8a49c1ea2d5116ac739b2c81723dbcdab"
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
