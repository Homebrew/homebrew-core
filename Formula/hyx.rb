class Hyx < Formula
  desc "Powerful hex editor for the console"
  homepage "https://yx7.cc/code/"
  url "https://yx7.cc/code/hyx/hyx-2021.06.09.tar.xz"
  sha256 "8d4f14e58584d6cc8f04e43ca38042eed218882a389249c20b086730256da5eb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5fbf9736e6dbca570698341b9461ef3e9ed520be32f1f665964bd7162b337e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "876cce3d4991699d1a91ed15aa402cd0498e41b140d4bd371bc87763f71ece01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de87aff5b103cee974a250ba5bf0dca561a9f4cb04fd03dee1891655cb631740"
    sha256 cellar: :any_skip_relocation, ventura:        "b064d27cb24cfa819b1eaaa3caa496eeae0bfa2dc6c83af2107493f46287f995"
    sha256 cellar: :any_skip_relocation, monterey:       "5251235fa71e58ff19369a82f34f9ab76f7888371ac8cfde95cc787d2d62cef3"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c1473d66c1da0f19c5f67ac5bba53dbcd2cf009181489359f33712b023ff355"
    sha256 cellar: :any_skip_relocation, catalina:       "194956ffbf2acb56d0b8805c6391f54da20287636add769e229ceaf05bfa6497"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "231df463b5d75e449a6da43bf25d1d9339f77901f0a0165d3ef09e5b0dc01e50"
  end

  uses_from_macos "expect" => :test

  def install
    # CFLAGS set here because the defaults are not compatible with Clang.
    # Issue reported upstream via email to lorenz@yx7@.cc on 2022-07-19.
    ENV["CFLAGS"] = "-O2 -D_FORTIFY_SOURCE=2 -fstack-protector-all"
    system "make"

    bin.install "hyx"
    doc.install "license.txt"
  end

  test do
    assert_match(/window|0000/,
      pipe_output("env TERM=tty expect -",
                  "spawn #{bin}/hyx;send \"q\";expect eof"))
  end
end
