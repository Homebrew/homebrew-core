class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/refs/tags/v1.19.4.tar.gz"
  sha256 "a2df9d5411fc53d97ec17c069765c8fb781f8dc36c4e06ec1cd4b189340d364b"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "080a1b66922ff7564dddb9bddd0a9d0832468aca7a6e9118ece4e85008ce9add"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c46a16fb5d97ccb4fe2255df8e69a57bc44087402c860fb12c3a3e4c7db3d0a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2aa3a3de98c03b61f63fa8cb6466a54d588e6a67637d90c6c1964d6ea393646"
    sha256 cellar: :any_skip_relocation, sonoma:        "6614f4794a58c92218754ecafdaaf122db27435d0c0c4e97e4768575cc435810"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbceaec07c6006c9b79d3bf66c4bb3d49adc840400c35a633c64af5700cf3ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e11e1d24b4b5c47af5e74115591923c75c2617b534b13f0be87ea809877ce33"
  end

  depends_on "erlang"

  def install
    # Set `Q=` for verbose `make` output
    system "make", "Q=", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match(%r{(compiled with Erlang/OTP \d+)}, shell_output("#{bin}/elixir -v"))
  end
end
