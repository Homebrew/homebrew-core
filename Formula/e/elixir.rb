class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/refs/tags/v1.20.3.tar.gz"
  sha256 "ff22a894b130631443db1a193b4e8cb4762f697128566e43da848fd16c3777bd"
  license "Apache-2.0"
  compatibility_version 5
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fd271048da435dd14e7973373804f4f88d44cd91881bd5c5ec01d42f2166496"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcefd4c03a1c7bde292dd838c4e5b08ea90cde8cc35e2746e65acf243afa7029"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e68220a48f915bf81211e68ba3ace335398dc84b8c9f07516543b8e91167422"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfd1860efc80b9df4294ae3e0381e5fbe4db15257469c5edddd3f7480fb88173"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d87fdfbb81758b5d74006beda945295d345dc3b3da8474b0ca7b7d363f3c05ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4722f537a599ef838ad01298ee004bb5045fc53a0ee860ce5ea525faa5743fee"
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
