class Fzy < Formula
  desc "Fast, simple fuzzy text selector with an advanced scoring algorithm"
  homepage "https://github.com/jhawthorn/fzy"
  url "https://github.com/jhawthorn/fzy/archive/refs/tags/1.1.tar.gz"
  sha256 "93d300d9c6c7063b2c6bda4e08a9704a029ec33f609718cd95443d1a890aff4e"
  license "MIT"
  head "https://github.com/jhawthorn/fzy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "995c482566e82fceff774a07f6d4f7e425a73417bfa1d6bc2d6d59b3db4be88b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b83d328d34cd94be151f2fef52644d42661b7da1f432973c1f2920fedda2d87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8e1ab18d6ccf34ab507143f0528223bcc8034c49c7584a7704d3ddb0cce20ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "002ac1934f80f378487353a650abd8bd3db970846ff033e3bce9b852df7667e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "08ccd6d7441ce786fcfa95f7431d797a8c7c319fdbc77b68caf14303e80a1ae6"
    sha256 cellar: :any_skip_relocation, ventura:       "0143418a513be50762b0d7783ac5dbd42cd86c1011b499df62873aa6fc7f12a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62aece1b17591bfa75cffc0e55b3db3decd30c9773fad120f58639f71f7f03ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad34b2e3d520a22b34e253c0b73aaa164facb5728bee8fd811513551ccfb94d0"
  end

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_equal "foo", pipe_output("#{bin}/fzy -e foo", "bar\nfoo\nqux").chomp
  end
end
