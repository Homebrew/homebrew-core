class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.15.4.tar.gz"
  sha256 "302bf8065ab792a88f6c3a0c01a6bb58737be3e4fc2564c8afd418bf9792501c"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dde39c9210b9739415544b9f735f9c452af1c1c053296bf28841fd19de6323a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b4608dbf7c7a9f9c312e8658c36316455429c868d3baf6c63e1b0c63e328d8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45953a6601a68ad2a5b94978beb67a4241612e5c65c53bf01c52df64685c3686"
    sha256 cellar: :any_skip_relocation, ventura:        "47f1779f5931cb66a8fba149d458e5699570374649cd34155b3379e58084100f"
    sha256 cellar: :any_skip_relocation, monterey:       "0bf0279e32a73c359f7ea2440a14b9a2517cd5427162c43976fb35b53ee3f20b"
    sha256 cellar: :any_skip_relocation, big_sur:        "56f3a3c7610c09b799c77c10c6ef3460a8c9a6c3f5a350c84396070ad766fd79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "998353cbbdc1ca322a5b86a44d20575b2f71024fe0c43279cfb15d0ef5277004"
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
    assert_match(%r{(compiled with Erlang/OTP 26)}, shell_output("#{bin}/elixir -v"))
  end
end
