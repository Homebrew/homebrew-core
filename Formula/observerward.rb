class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.3.31.tar.gz"
  sha256 "6f5625084a0ceee1a3f32c867dd9a2f64e5991497a2f43129846f45ed56d5da1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4370df1c0046a6c205a3f3ccd29cb1463797923f57a6752b9b887b9c70e0fc38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90fba45e8941d7d4260d43bfb2b059f3b676087bb508e1c316d23c531dfd22fd"
    sha256 cellar: :any_skip_relocation, monterey:       "f4f0e5181fb156cad96e38bb335c1ebfebd4133eb310fc309bf96a5091793eb4"
    sha256 cellar: :any_skip_relocation, big_sur:        "408018d3a419f1399c7683626c2473f40616b44e428a9b9bdae4644fc5046af7"
    sha256 cellar: :any_skip_relocation, catalina:       "909c902d813c22f659f5d4056c53c806c3ae69c2b89b6c71a6a8b7cd2db7cecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c82942bd009d68210b42ad4026f712135f76e4335c04915bc37be7eb937cdda"
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
