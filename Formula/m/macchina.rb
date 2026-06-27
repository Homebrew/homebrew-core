class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/refs/tags/v6.4.0.tar.gz"
  sha256 "edd7591565f199c1365420655a144507bcd2838aed09b79fefdc8b661180432f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7b34599b2e3d2973b88aeb0f9a84f168419455377c74dd295e0101ddcea9934"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ced4610d20e2d1279ae391a02ef966e22984dc0bf615b6341b9672a45d2d0f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e8e972a287563d557df33bfeee21eb54fb2bd13ae2399ed0451e6381aad554b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0edf9f8eb64c603d3d2a173a0d933902ace99b500e16c8a3cd7daec854703232"
    sha256 cellar: :any_skip_relocation, sonoma:        "922e43abc17df8b48ffa744fd346f50f60754ea4abb2a5b82703b94686f91620"
    sha256 cellar: :any_skip_relocation, ventura:       "d544f58c1d3f84ab87fded15c43ee4deb67e18c3f2a3d81e40919875a795942a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5597f411de344cdc7261ae72f1262dd5c9f0aa02201d76fc2e0d95adc75106ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2dee8bb6fa398bbe5e7ed7dc13dbf811d9511a131a9ec678aa487b323e2528b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "We've collected a total of 19 readouts", shell_output("#{bin}/macchina --doctor")

    assert_match version.to_s, shell_output("#{bin}/macchina --version")
  end
end
