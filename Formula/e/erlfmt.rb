class Erlfmt < Formula
  desc "Automated code formatter for Erlang"
  homepage "https://github.com/WhatsApp/erlfmt"
  url "https://github.com/WhatsApp/erlfmt/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "7d566b5f012ce4e2db74e18edb7da4cf69fd49a2f80effdddf989f5f0051db5f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8266549882d41150de0b66f5fe7bd0f0e92785ba30f11ab3dee28926b428af77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35cf96980aa95b1827ddc80ff3a73c7def29582162918a7a4291f71cb3cb5682"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb2615b10e79037ca5829a4ae1d6e25236692dd79fa4f4ada1f5f620b87e9bfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b0d36b3e481516af2a54382c6ea13989a1714a3964acac0a315f370147f8ba4"
    sha256 cellar: :any_skip_relocation, sonoma:        "24f2788f4e3f9a4e2df567e36ba06f4037ca5274e9be6b68a82503c7ec23ace1"
    sha256 cellar: :any_skip_relocation, ventura:       "b53833e0a2290c18e78cbf5eda5c894884d760d09e9cd67e39bd56de291c3baf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39f6c7f3019dc5a30bc588bada8d02f55c44f351bf492f6e293d069931fbaeca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77628bb5ed178d45716e074c0a3196d57c5d3a5598bd03772fe5c8d9be7c4819"
  end

  depends_on "rebar3" => :build
  depends_on "erlang"

  def install
    system "rebar3", "as", "release", "escriptize"
    bin.install "_build/release/bin/erlfmt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/erlfmt --version")
    assert_equal "f(X) -> X * 10.\n",
                 pipe_output("#{bin}/erlfmt -", "f (X)->X*10 .")
  end
end
