class Fst < Formula
  desc "Represent large sets and maps compactly with finite state transducers"
  homepage "https://github.com/BurntSushi/fst"
  url "https://github.com/BurntSushi/fst/archive/refs/tags/fst-bin-0.4.3.tar.gz"
  sha256 "13d1b28a6a6eaf5ce53c1840e7e6c2cb42ff7f846cd57047ddd32601667c8a5f"
  license any_of: ["Unlicense", "MIT"]
  head "https://github.com/BurntSushi/fst.git", branch: "master"

  livecheck do
    url :stable
    regex(/^fst-bin[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c534ae0a86b7877c91a52b122d2be15066ca1c4a7d0e6f00fc99ede4d256bd45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8ec7353ce5d9f6c88ae018bb0da9dc32555aafdc7fa4aa3202c1d9a49e397369"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e62616b2c34ac331d45710d3ca6da27a4599eeb71cbf1d7e3b0991ccdaedcae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ad7bfd34ae243f510522166d02bd9fc1ad24488cfc16a68d25f96e84ab1ec87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e96ce0a1e5e150f27ed111738f01576734e65a4dd1d5799bb3819df0c91d363"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "046025781603f0f516c317c8f87a9e2a106eda8d1fc5a2e19303e17d0b4e0b1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "520dd3c08e060a52f0b211da885327fae71f272cd929d5e41c31ae71970e3413"
    sha256 cellar: :any_skip_relocation, ventura:        "b2674c7f7e94b5381849dd98ed9a17556e5cabd43ff4696d796f2489884bb7d8"
    sha256 cellar: :any_skip_relocation, monterey:       "c947b6915cd67c7c86b1606ab6e9f09ff4aa258ce0282125da3b3072fa06445a"
    sha256 cellar: :any_skip_relocation, big_sur:        "daef781d826e2aa4384e136cb9c815b603676b0a7b4376b646619f0a03fe5790"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "79acea200a497ed48c7ce6d0a8d1ab514df4194df6f2218a5402fce9f7840177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e05329c5e355ffab20c7a71127133ff6f961b0c36fb5ef2509e5c159cb517e8c"
  end

  depends_on "rust" => :build

  def install
    cd "fst-bin" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"map.csv").write <<~EOF
      four,4
      one,1
      twenty,20
      two,2
    EOF
    expected = <<~EOF
      twenty,20
      two,2
    EOF
    system bin/"fst", "map", "--sorted", testpath/"map.csv", testpath/"map.fst"
    assert_path_exists testpath/"map.fst"
    system bin/"fst", "verify", testpath/"map.fst"
    assert_equal expected, shell_output("#{bin}/fst grep -o #{testpath}/map.fst 'tw.*'")
  end
end
