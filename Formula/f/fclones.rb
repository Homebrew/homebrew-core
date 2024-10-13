class Fclones < Formula
  desc "Efficient Duplicate File Finder"
  homepage "https://github.com/pkolaczk/fclones"
  url "https://github.com/pkolaczk/fclones/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "5e8c94bb5fb313a5c228bdc870cf6605487338f31c5a14305e54e7e3ac15d0ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "066372287675aca1dc5b9235734ad7eacd79945e6ace1992ba97fde2241e6701"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d720767853cc23dd6fb8a35008d39c8b005f99b367c0d260b1197d1a9d4c19dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16fa6fb02ca993ef54bd942f18860dd602ea04946149c296fabaaecde93dd55c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68841eacebe1435bb4e39325ed55522bc51d8668ceeb7f108fb9482c7c32f49f"
    sha256 cellar: :any_skip_relocation, sonoma:         "87e479b0556ee718fa992c697584d1c64eb6e8d55c1fc30ce0d2851179bff293"
    sha256 cellar: :any_skip_relocation, ventura:        "30095d67ac23b747bddc931e8a083394809b22e7a479f390d50b234a7e045481"
    sha256 cellar: :any_skip_relocation, monterey:       "dc7a8ba4486994b7296fda40c49d0df7c7178042b55677ec64a333ff9e7455f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "774daef5f511aac75797d39d11b8076ab58a6e004fbb604dc4a4fd7ca1c2d802"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "fclones")
  end

  test do
    (testpath/"foo1.txt").write "foo"
    (testpath/"foo2.txt").write "foo"
    (testpath/"foo3.txt").write "foo"
    (testpath/"bar1.txt").write "bar"
    (testpath/"bar2.txt").write "bar"
    output = shell_output("#{bin}/fclones group #{testpath}")
    assert_match "Redundant: 9 B (9 B) in 3 files", output
    assert_match "2c28c7a023ea186855cfa528bb7e70a9", output
    assert_match "e7c4901ca83ec8cb7e41399ff071aa16", output
  end
end
