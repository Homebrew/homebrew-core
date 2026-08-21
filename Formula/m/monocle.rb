class Monocle < Formula
  desc "See through all BGP data with a monocle"
  homepage "https://github.com/bgpkit/monocle"
  url "https://github.com/bgpkit/monocle/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "0c0253533ab4a99cdc0fb825b6390ace9eb7f4fb27e6bc23d151ef98b630422b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cbba5d48c749142396af5c6abed524450035fdab8c20a6163d06c5c488026d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6ea5e134bafb723e61e5ed755d92904f282babef35f48f5ca6c36752112aa38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ce6c631522449e27955bbb7526d9e54fb428c13aefcbb6d6f848ec6aef1ba58"
    sha256 cellar: :any_skip_relocation, sonoma:        "59ba05cab8ea7e825a73354adf35810c5f4d4e769a5fbdc9dbf3e6c0060e2505"
    sha256 cellar: :any,                 arm64_linux:   "275dc8a64e9ea6577787498227258fbdb2139960099753a8ae0613d3e2264d38"
    sha256 cellar: :any,                 x86_64_linux:  "4f63743098962b3a36660112556f4343d9a3a8d8841a231cc8e95428074dcd36"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/monocle time 1735322400 --simple")
    assert_match "2024-12-27T18:00:00+00:00", output
  end
end
