class Cgrep < Formula
  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v7.1.0.tar.gz"
  sha256 "4d590b00ff63fe2d9b3c57ec16f91d73b4f21ea012036b4e4d7ee2f40bdce417"
  license "GPL-2.0-or-later"
  head "https://github.com/awgn/cgrep.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4edce520ce4ee01216af5d14448cd7ba1275633c884c096d1fec589e840abd12"
    sha256 cellar: :any,                 arm64_monterey: "f64aa814af7f0fe7f0fc2c9cadc88bd56b09010562c0433131919b68c22002e7"
    sha256 cellar: :any,                 arm64_big_sur:  "13baf2feefe328717fe25dbd8cb2663eab455a1acdddc9dbebfeffb2fbf7ef80"
    sha256 cellar: :any,                 ventura:        "671cf5a2ad4bebd234785b355d8314cc7736ade142659c0797cf9e6bae397a74"
    sha256 cellar: :any,                 monterey:       "841a24cf2eadfef1521d92d3e72d4dd3cf73f1a0b1180774737591fa9c49a606"
    sha256 cellar: :any,                 big_sur:        "ee626eb6aa687f9a4caa721b1d2fb1d259b32baaf81fec1004be8bb974c2cb16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "809f7ed16efaca9b535162bf4caed07abde47abf8465380b768acd08bc81c305"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"t.rb").write <<~EOS
      # puts test comment.
      puts "test literal."
    EOS

    assert_match ":1", shell_output("#{bin}/cgrep --count --comment test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --literal test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --code puts t.rb")
    assert_match ":2", shell_output("#{bin}/cgrep --count puts t.rb")
  end
end
