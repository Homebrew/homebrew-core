class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.6.29.tar.gz"
  sha256 "2198abd74bd728510f386957faf9dc2154c8748abcd8c27e25298ecabb0b98f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93d1204dcc67fac7ff6e89d56a3b2c89ba5c6d899c17aac7605da976549fb748"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32a9096b970e2eba76f428f5da73dec5a04b34ade90f9d04a546719a4ebb0c81"
    sha256 cellar: :any_skip_relocation, monterey:       "793afbad41b552a0b65aa9bfe9d9bd03ab895abb396d334f3713634a4eb975c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e0d50c595d9e09e3d18aee18b69198af440c0112604fcfbf94a2e45546bb169"
    sha256 cellar: :any_skip_relocation, catalina:       "8caedf71f5b47f390857b8f3afc15e43dae9b103ff6cdd28ddc9b2a613a108d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13859ffc74604c3fc628759db24ff26816a18df15cc7d26aa3470625f7278536"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "swagger", shell_output("#{bin}/observer_ward -t https://httpbin.org")
  end
end
