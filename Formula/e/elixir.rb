class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "70f6cb721f238fa5dd33eb29aa5b19e5ccc3807e41cd5f9b65d5c715b669438c"
  license "Apache-2.0"
  compatibility_version 2
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f148271eb3e5cc0a9e8ae8f1d9514a8168a449d18138be1530a49e74b4ca9ff3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fce8d4e392f3de3d747f6005dd4fb13afc91dff79f4b2e0bceb6aad9ef9494cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce7594b0cceeea2c8551c66c8923bf3926c7068caccc7f4c34f9bcaca2050124"
    sha256 cellar: :any_skip_relocation, sonoma:        "83559e7a1f77e80d818682c13235d7e494853167b8beb6dbbfa51569c289cadf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b5073e387ca371cc6186cec077ad7775f5e3f48fdeed0c2a4d0da143e3712f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90e86f04f132158be0eb340aa40f94c679025d86a3f05b3721367444ee45d054"
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
