class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.6.14.tar.gz"
  sha256 "d67af3efacc181c20b3b0a4f16616e74d19565498e56ab78ca5867fa71564b59"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eedb6b3d81ef43f87e68b2b7848acf8934524b70ce69cce5d8fece1418cab102"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c5350c6369b1044e562eac2a6cfab024bbfe251619eb317d5a89f01828cc7bf"
    sha256 cellar: :any_skip_relocation, monterey:       "b5179c8ce164bf7c77677a91f7801f405106f31e00b7039c747af2849d77c752"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0f9a33454d8bd0d33b15544c3c0d5397d0c18de863557168e2791bf678ab79f"
    sha256 cellar: :any_skip_relocation, catalina:       "1acc1a5e20371010b5bd7ac34c1c2e0edc24ed032982b7e59e449a0c2c88dd69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf94b7bd4025362ff148948a1fa005247140ae7ec8c21fd943de52f6d77dad02"
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
