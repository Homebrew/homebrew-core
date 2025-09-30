class Hexd < Formula
  desc "Colourful, human-friendly hexdump tool"
  homepage "https://github.com/FireyFly/hexd"
  url "https://github.com/FireyFly/hexd/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "de0db7205c8eb0f170263aca27f5d48963855345bc79ba4842edd21a938d0326"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78fb673214aece803927239e51d3b92a134d2dc71bc13bfec30a41cf49f8ef2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05ec65d79e0eae2ee7291cbb5fc523358b97e0f93a5b5cab039d02b27aa39230"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6258b4701ae5d49c39ee122ad9988d9647141a3c62ae49923dacc5086617c1f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "542333622e6a776e913cd72d820671ae3da80180673f3f6ce93e911816f04b56"
    sha256 cellar: :any_skip_relocation, sonoma:        "45a53e8aad1758074bbffb8e618a19c25645547d883d5f4ccf62cd2ac312658e"
    sha256 cellar: :any_skip_relocation, ventura:       "dacdc00f2ad09c469316c672491b47d4242bf119eea23ed4de2d361518a3b7f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a4f51eef0ca22a531e73b1b6bc75ae06ed9e987fee0d94a612121651577e22a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b62eca23b33b5257e4fb33ec61b9301700d7c732c2efe2037952fdc3b9e8cf8d"
  end

  def install
    # BSD install does not understand the GNU "-D" flag.
    inreplace "Makefile", "install -D", "install"

    bin.mkdir
    man1.mkpath
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match(/0000\s+48/, pipe_output("#{bin}/hexd -p", "H"))
  end
end
