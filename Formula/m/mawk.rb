class Mawk < Formula
  desc "Interpreter for the AWK Programming Language"
  homepage "https://invisible-island.net/mawk/"
  url "https://invisible-mirror.net/archives/mawk/mawk-1.3.4-20240905.tgz"
  sha256 "a39967927dfa1b0116efc45b944a0f5b5b4c34f8e842a4b223dcdd7b367399e0"
  license "GPL-2.0-only"

  livecheck do
    url "https://invisible-mirror.net/archives/mawk/?C=M&O=D"
    regex(/href=.*?mawk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "88e2f1cdc8f13fa9a28231f8a33010a40c4f14111331eaee53e54a6155e80439"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0eda76d6a691dc893fed95070390f73d3e7f5d5d6a778d0bab72310d9428434"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13ed03c6844dae57c9ed1a2f0c9dffaa1619fb33e3888184b8192919907e1138"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d967db94a1cb92a105c04265706f2d8ed9393fe4d70e217cd888a0413d35973"
    sha256 cellar: :any_skip_relocation, sonoma:         "07eba409d5f6afa62eabb08e6b3366272af278069b5574f8d87494de16e2b182"
    sha256 cellar: :any_skip_relocation, ventura:        "e81f378d3d3de604a2480c1eaf2225ce435b69f35d60e6d7dea2c6872cdf90e3"
    sha256 cellar: :any_skip_relocation, monterey:       "61e26c8d9b0ce964fe61c515f0e501db8efdc8273fffa2def9f3d158e4f9ac27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57dbe7179991e40420ae7f79f6552a877e7c7a3d4798e93353a260ae6d3cf2a0"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-silent-rules",
                          "--with-readline=/usr/lib",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    mawk_expr = '/^mawk / {printf("%s-%s", $2, $3)}'
    ver_out = pipe_output("#{bin}/mawk '#{mawk_expr}'", shell_output("#{bin}/mawk -W version 2>&1"))
    assert_equal version.to_s, ver_out
  end
end
