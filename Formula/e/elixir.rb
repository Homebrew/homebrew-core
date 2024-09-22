class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/refs/tags/v1.17.3.tar.gz"
  sha256 "6116c14d5e61ec301240cebeacbf9e97125a4d45cd9071e65e0b958d5ebf3890"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83c653d7dadeb4c71c3553ac242c0f10cb9e37875e8afd8a0f39bf521c42dbd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbae081b57083375227d4db7ea0ae3da85c3161003571ee66d910c6cc4dcb8ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a1a4b967ba096b058e4a207a170ad53e63567c9923a7f52a4ee0d35e847d4b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2434124c621056a611a2bc69d4d1a1e87844969c2d8af9726fca59542bce9ca0"
    sha256 cellar: :any_skip_relocation, ventura:       "a36d73800c53df561c45caa34455d4c61e133ba5976ec85f369d4e2d0c362272"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f64f95d70b861706bbdb653d48ef4e3c3fa5b265755212464797274a933ac6f"
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
