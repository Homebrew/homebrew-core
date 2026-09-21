class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/refs/tags/v1.20.4.tar.gz"
  sha256 "2f87be1702583ecbeee82c0ad4d6353de96463cfa0fa6e7557e05f68d90da869"
  license "Apache-2.0"
  compatibility_version 6
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4c56732b58177de6ef0b6790f8c0fcb6673adbd6b2626673be10b091b0bb1368"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2db0649adb38e6bcbdb1198d43851886fb1dda4585a643df3752b9ae2c6d9206"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "66789763645f9ab609a834e12bf3152cfcde2b09cdec97b5de46dbebf67798a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "3a4a493efb376e6929fc0a22f3ddb2680305f6abd0c408009d639da5fa4fe951"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c960d2ed069fc1f92c64f72b751df69c5d2fdc45f29f007e58934f969c112bef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9ac2b69aea3ec5889429cdc0223ef2d1883c9d6621e875ce9b07bb81d261dbe2"
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
