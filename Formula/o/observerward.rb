class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https://emo-crab.github.io/observer_ward/"
  url "https://github.com/emo-crab/observer_ward/archive/refs/tags/v2025.11.15.tar.gz"
  sha256 "0b1b3b24316ff4a11007cf10fb58068fc76224d264354cf54fe71407c7837931"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6eb4a70697e05d041c9dc75b552a8a56a7987586be6025961f70f8767937530c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4d34008753f7d16271ed2557419088df541ceb53227fee0580f2bf077f17e63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6757b1ebe4fd2eaa3d118d420f168acffeb35bd8981942801365dbbfb3137855"
    sha256 cellar: :any_skip_relocation, sonoma:        "469fe875cbccba5360f5a211bf6426dd2a7445ddd03045fd24cd4acd28a8ee3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc067449e1fdc5778d165163cff8a3c51e8753488d9cbd23d7f9c9d30777a30c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea5cdd0adbbca8feb92655f0c45e0e5c42531cb0e6f9fb64061a2b10e374f14b"
  end

  depends_on "rust" => :build

  def install
    rm ".cargo/config.toml" # disable `+crc-static`
    system "cargo", "install", *std_cargo_args(path: "observer_ward")
  end

  test do
    require "utils/linkage"

    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")
  end
end
