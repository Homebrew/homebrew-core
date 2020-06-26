class ChooseRust < Formula
  desc "Human-friendly and fast alternative to cut and (sometimes) awk"
  homepage "https://github.com/theryangeary/choose"
  url "https://github.com/theryangeary/choose/archive/v1.2.0.tar.gz"
  sha256 "5711a301e8cc7a5f257773feef992ce8da714a9ee167f234943203ee36c923ad"

  bottle do
    cellar :any_skip_relocation
    sha256 "8fa22384529ff492abd9859f57b7b771e0f96f911ef0a56845154c8eff73fc4d" => :catalina
    sha256 "8753e0f24b129a4417ca550665517946aeec068d94dfe1cc129685bc8f74aafc" => :mojave
    sha256 "fa2a955907368022bd282626b6043d1ed6647d357eff05cdd634ae809ea33b9a" => :high_sierra
  end

  depends_on "rust" => :build

  conflicts_with "choose", :because => "both install a `choose` binary"
  conflicts_with "choose-gui", :because => "both install a `choose` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input = "foo,  foobar,bar, baz"
    assert_equal "foobar bar", pipe_output("#{bin}/choose -f ',\\s*' 1..=2", input).strip
  end
end
