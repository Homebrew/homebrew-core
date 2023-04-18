class Fzy < Formula
  desc "Fast, simple fuzzy text selector with an advanced scoring algorithm"
  homepage "https://github.com/jhawthorn/fzy"
  url "https://github.com/jhawthorn/fzy/releases/download/1.0/fzy-1.0.tar.gz"
  sha256 "80257fd74579e13438b05edf50dcdc8cf0cdb1870b4a2bc5967bd1fdbed1facf"
  license "MIT"
  head "https://github.com/jhawthorn/fzy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa5003d2177cfab28c1a44199fc9aeea2351c2480b5ee4cdbfe03f3b855569b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "594f670b4c7aead7e05fb1ee3b756d6373abe49c8a05c9422acee94a932ebfcb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80cdff748840ffa3b7f85b79839b776ba8c24cd8d5e63d6dfa9c3e34cc97717a"
    sha256 cellar: :any_skip_relocation, ventura:        "822711ed5bad961b13e20f748b816bc35957fc0e51dc9ac57b6eeac4a3ba4547"
    sha256 cellar: :any_skip_relocation, monterey:       "f86b3980fedf4bd190cad2a289985b42fa664a022373de292c5441a1d2ea581b"
    sha256 cellar: :any_skip_relocation, big_sur:        "31d5e7d85d6ca41615eb96700184659116d35b4fba2c8809b31a3bdefb348fe4"
    sha256 cellar: :any_skip_relocation, catalina:       "d517947fe59a7b4c577245cc7f1e7124aa65dfb95ae67175e1ebf3d3d14ac35e"
    sha256 cellar: :any_skip_relocation, mojave:         "2f7d67a61ad3cf284ec15d95e2f5eedaf1cf0ecb63ea2a8994df9733160b3a2b"
    sha256 cellar: :any_skip_relocation, high_sierra:    "fb173da3b703940c9dd8c942ced0db3c068f544be59fb01ccfe835f566d13cef"
    sha256 cellar: :any_skip_relocation, sierra:         "b478e2604e81faf0a2e7278afe2f811ff1739528f246fcf2556e05a81f1d3435"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "696df3c3d3296b1b03bcf0e75eb7d7bc73f004fd15fe7f7899aa10dca7d3e6f6"
  end

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_equal "foo", pipe_output("#{bin}/fzy -e foo", "bar\nfoo\nqux").chomp
  end
end
