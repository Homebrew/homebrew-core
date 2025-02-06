class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "efc8d0660b56dd3f0c7536725a95f4d8b6be9f11ca9779d824ad79377753e916"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c2665e744123cf29fcac7484f10bb59585e13c3dae208262904cb737da3c9e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd0a0b4c36a4d8fcb9ce7d8dcb340e76e1ea3c3789d8b3375fcec360f8de0ecc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9bfe4a236835d3a95ee2105df3c67948ab3ce89c7287ce911a813ab8d50d265"
    sha256 cellar: :any_skip_relocation, sonoma:        "50954f1baac8736b9927e746e2d791b7e53cb17ab0cd5687cd37997790dff048"
    sha256 cellar: :any_skip_relocation, ventura:       "0e3a9d290a75b4b472bfcfe2b3081d14dd0cde2a61d97ad296d3d3ea3bfcaaf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93d268aad33b7618903b1edf719abb89a9f0c4cc745971ea0c696b5f03790c18"
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
