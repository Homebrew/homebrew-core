class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/refs/tags/v1.19.5.tar.gz"
  sha256 "10750b8bd74b10ac1e25afab6df03e3d86999890fa359b5f02aa81de18a78e36"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "786c67ab9d62cbc12fa8d4f82ba793deb6e1709ae17893e56052b3898b242b9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ee758eff7bf952f2ce1e9d185e7e282da61a3f820442ba274584ef27e001d8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33b2ef7a55e6baa0333700bc147f9d463f70cee44b045d6d6f4264710889d588"
    sha256 cellar: :any_skip_relocation, sonoma:        "472c46ab5c968e22076c4fae7d1bd1a532dd476707eea57c4b5f0ee04eff7aaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0301eddeaf80ff83bdf56b419c5e176914cd8b0e620ba309c65b3f182bd12f35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8443035821fa8345ad64183634b17e8945736331c8d9692e28424341a3058cbc"
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
