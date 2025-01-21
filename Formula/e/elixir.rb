class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "4235a63c615c7c787d85a5167db28a58ec9f5a579f9b3fd853fc6f4d886c209e"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57299eda07dd7828ed49a6697280a7079375df510e4cd9f98e5efd544e8d8b11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "148de68f0a9b72b708e79a403a39e894cb12f12135b1f52ed1ed3d02e81c5330"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e690f1b324f3e13e6a432c4ba48cb09c85a22d91485e13e91a6adbfc8a2a5b91"
    sha256 cellar: :any_skip_relocation, sonoma:        "17695aed04824090e6f712a5429a58b2dad589c005608dcec8875d51ece22b8b"
    sha256 cellar: :any_skip_relocation, ventura:       "bc58af09eccbdb2724bc469b8b65c9ccb45d6b2520b0f7c18054820356f377d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d60e83d04aa8666dfd8c0c7c5fbb627fa260bc94de5677ba31ec8342616413d"
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
