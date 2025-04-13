class ChooseRust < Formula
  desc "Human-friendly and fast alternative to cut and (sometimes) awk"
  homepage "https://github.com/theryangeary/choose"
  url "https://github.com/theryangeary/choose/archive/refs/tags/v1.3.6.tar.gz"
  sha256 "3d28dc39339dbf5c6197eb803b199661d6d261bc827c194b31b19d1afad01487"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad17bcef06080d2bfb71bb181c458c30e52d9d7286984e773f19421549090901"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3a242fc57b9ead20e8eb5d1d60d14b3f3a53512a6bfd4765dc4fe08655a812d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8bf5781d97c33bfbff80f26fe6816e931b3e3e95517f827f67946fcc02325321"
    sha256 cellar: :any_skip_relocation, sonoma:        "a95a7d6cd3898ea70ce60d04af20ede743fd8a77cb200ae68616dd5fbe82b300"
    sha256 cellar: :any_skip_relocation, ventura:       "1843f24e22d57a1eb64fb96ce845cdad40e9c84d5199cee8002c3aa2ca0fe11a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a64165c7881c9583a85b19fc3074d2209fd0a1db3e27cb1a2a84971760aeeccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e95d29a0116297a407d108626121d3be663f3c856345a279f3e5a0f17887834d"
  end

  depends_on "rust" => :build

  conflicts_with "choose", because: "both install a `choose` binary"
  conflicts_with "choose-gui", because: "both install a `choose` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input = "foo,  foobar,bar, baz"
    assert_equal "foobar bar", pipe_output("#{bin}/choose -f ',\\s*' 1..=2", input).strip
  end
end
