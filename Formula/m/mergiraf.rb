class Mergiraf < Formula
  desc "Syntax-aware git merge driver"
  homepage "https://mergiraf.org"
  url "https://codeberg.org/mergiraf/mergiraf/archive/v0.16.1.tar.gz"
  sha256 "168711e3f7bc7fd1df0e5d7154004060c9aa682ffae9092725c09e119a6da7b2"
  license "GPL-3.0-only"
  head "https://codeberg.org/mergiraf/mergiraf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95b9580f9eb98b532de1a9e3bc0161b3993d432446a714c3e32cc398cd002ebe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af7466b5d87ae73412fc6dbca374b19a818e8377dc7f04726363434402c7011b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2101392411977e24f6343f660813baa8f7bcdf4a5f85fb661128b39937d34de7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f26ba8f3ca7bbba3868034ab568f6cde7d05258bab55425716da8a595b9018f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c8139ce7291806c3acacd8e177de1c7e7a7d3493ac5d8a8311881127fedcab7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cddcb6f2cfe718c2b5a83acf52cb9f61eed9b8d9354483949bb767f88c1a3f8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mergiraf -V")

    assert_match "YAML (*.yml, *.yaml)", shell_output("#{bin}/mergiraf languages")
  end
end
