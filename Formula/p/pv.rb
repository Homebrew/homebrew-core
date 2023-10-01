class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.8.0.tar.gz"
  sha256 "5cec4f737826a0eddab471dd3b75a587bd29a2e7cfa30068d57f29439a251fdf"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d03a02c1f60ba710b78e10a30ed59da20b3768acff51b1ccce8138df027eb7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a07d9410e6c15610ed82ac7e7c662c362e26c40d3367001b0d85efaf321cdd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "890f5317814badb2050f1a5231d0a64502966bb563972325967f065af6cc4dc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e45dfcb270088dbc3a4c521070e9814d948bdf54ee36b684a0fd5d3370cd6026"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad82a0b9e77c9b796c544cde48363046343dcdb6cde969e15eab338929165afd"
    sha256 cellar: :any_skip_relocation, ventura:        "71f3b7e2f617271bd2be82a3dca0f55833aabc3744b3c4845ca8e2c4ff28c7f4"
    sha256 cellar: :any_skip_relocation, monterey:       "6480f84df82a716ecadfd72bb272380166d6d608f75a7d2684aed84495eacbcf"
    sha256 cellar: :any_skip_relocation, big_sur:        "34e71d73c3dc780411072eed36a4e4fefdc935c25709147ea45e7f22a6ecb600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e222bbec826bc4e86b743024c7c65bff12c686507eb1cd4d13fa06fe662aac4"
  end

  def install
    # Workaround for Xcode 14.3
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--disable-nls"
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip

    assert_match version.to_s, shell_output("#{bin}/pv --version")
  end
end
