class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.6.14.tar.gz"
  sha256 "d67af3efacc181c20b3b0a4f16616e74d19565498e56ab78ca5867fa71564b59"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0712de48f9d1b4d60ba629eba7b8a5ceb625e9b9e73dd8e2996aea24b997c0a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6978bb997351d2074eab3b999b49fe3aeeeb4680f9273d96e1d2b7414bc4f0e4"
    sha256 cellar: :any_skip_relocation, monterey:       "e130693ae1c04fa5fa1ec107132907218897a4077b0b476b200f7381907e29db"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc5c728268f9a9075ff94222b99d66677749b4df3ab590ea36dd352107828850"
    sha256 cellar: :any_skip_relocation, catalina:       "b48ac48ef5bf24e326524a67ad0530ac19c334f932df59f8b7b6c1760c50dae3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9521d4e42843410a121940577b0a1035d8ada02899c925e6e18edaf74328d1f3"
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
