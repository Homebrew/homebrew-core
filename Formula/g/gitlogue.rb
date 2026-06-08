class Gitlogue < Formula
  desc "Cinematic Git commit replay tool"
  homepage "https://github.com/unhappychoice/gitlogue"
  url "https://github.com/unhappychoice/gitlogue/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "e0e7c7def40757a41081b0e76daab0fd9f40af2840028b382e02728dcf3e9c8d"
  license "ISC"
  head "https://github.com/unhappychoice/gitlogue.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "21290a3aac7b34699fb296a07466568ac963499922cc83695035d5a67570e4a4"
    sha256 cellar: :any,                 arm64_sequoia: "db85c092aa2bcc464548ff70999a7fbe50b034358103db71e12ffb96a8086271"
    sha256 cellar: :any,                 arm64_sonoma:  "aedb2f4a7ccf47b999d26d0b4ba39ec02890617f66f2ffe364c5234928b178e5"
    sha256 cellar: :any,                 sonoma:        "b0111b982470e77c7f3394571274b91876e2183a8252a65bc7da4f072efaebca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64583bcfa9046f025f7557863eccd6dcd038be9ff1c887a471aecd1ff195bf36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bde9e99988a373219a9b4401d32bef8492af25cb8a2bc8eae1f7eb39a9f577ff"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlogue --version")

    assert_match "Error: Not a Git repository", shell_output("#{bin}/gitlogue 2>&1", 1)
  end
end
