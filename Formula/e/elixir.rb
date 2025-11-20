class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/refs/tags/v1.19.3.tar.gz"
  sha256 "a76299ec8d14b43a84a03b3b700b9f912a64912f03ced8e024ae267b7e40c26d"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3464b716cd37d4b36528dc86bdd94dd4e5e3eb1fc886e0fc8ea99b0d9ec86852"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6129c5133c329abc684bdcec9862a5b7c496cf5ff7b36d357602a11838488424"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9226c676af5753fae38d17b56573ffd997a78ba4e794fd0fbbf280b2a89f0e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "639b97d2eb058d76fd9153363f3691174ccd3b48b6445974a22f9722db2aa953"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e123980d8b05b47333925dd25b93eb5e49b74ce0c09006fc68bea204abed851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c57c7aba0e19db25c779de6df953fa91c195e4e806079e6694f89182c0ef0ea0"
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
