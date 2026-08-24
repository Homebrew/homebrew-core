class Gluon < Formula
  desc "Static, type inferred and embeddable language written in Rust"
  homepage "https://gluon-lang.org"
  url "https://github.com/gluon-lang/gluon/archive/refs/tags/v0.18.4.tar.gz"
  sha256 "2d600af19c69efcd9412882e9d8f01e5842e2565a2d054772588e4aaffd7ec2f"
  license "MIT"
  head "https://github.com/gluon-lang/gluon.git", branch: "master"

  # There's a lot of false tags here.
  # Those prefixed with 'v' seem to be ok.
  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c563fe86a2e6e0c17ecaed68d7546e3091e2bc2ef8494d6a2843f2c7e11f17d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7c46393e1d923c733591940a961b6a50fd91b7f39b4c451a89f71ad2ad87288"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11fa81565bb1b5e14db2159d40825f1ee5016f31421faaa675802347e1058e86"
    sha256 cellar: :any_skip_relocation, sonoma:        "de9cbe7a1b1df90b1c04b2279191cbcec2928a3d8a993ce7e23528fd55c16049"
    sha256 cellar: :any,                 arm64_linux:   "c0b1801b7edf2d215efe3ac41926deb99f9b2c1b2eca27245e9f662af2fdb832"
    sha256 cellar: :any,                 x86_64_linux:  "696a18dc6a67856295f2d2a183e4c362abaeaafc3b01f6558c8da6d9370a13b8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "repl")
  end

  test do
    (testpath/"test.glu").write <<~EOS
      let io = import! std.io
      io.print "Hello world!\\n"
    EOS
    assert_equal "Hello world!\n", shell_output("#{bin}/gluon test.glu")
  end
end
