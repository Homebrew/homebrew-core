class ChooseRust < Formula
  desc "Human-friendly and fast alternative to cut and (sometimes) awk"
  homepage "https://github.com/theryangeary/choose"
  url "https://github.com/theryangeary/choose/archive/refs/tags/v1.3.7.tar.gz"
  sha256 "8f51a315fbbe0688c4a2078ba8bc8446d36943b6cce6ed9bbd6a11f33bd1a134"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29ee75f6320e3145ddb814c62a382081af35cc61dce9290994f0448b12def968"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94d22bef03f4ecbe41375afaeeb48a7e0d9cdd0c687479cdb4afc71218fe2857"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3ac961f6aaf56fd0b23dbf244cf436dde01de4d72fefe423c2e0c445cb3a38f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff8a2e46f3d9b02165fde562429102217e9cd118b741920a8a5092cfaaa24746"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c5aff224bd3e37c218473daf84fe3050e30159dff63181ca049085f6574fff9"
    sha256 cellar: :any_skip_relocation, ventura:       "a7efcf3746c49ccb1df9cf23f3d7b28758b83f2438578e861242af8bb89652dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45c43e8c557f4f2eaa9aefe2b02814db19366c069712e4d8fd102f64e0967910"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33e20443e1345bb0e001ca5b793b47d95dfacb06a14c2fd83c1778ad64c2c45f"
  end

  depends_on "rust" => :build

  conflicts_with "choose-gui", because: "both install a `choose` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input = "foo,  foobar,bar, baz"
    assert_equal "foobar bar", pipe_output("#{bin}/choose -f ',\\s*' 1..=2", input).strip
  end
end
