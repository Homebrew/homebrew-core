class Mkp224o < Formula
  desc "Vanity address generator for tor onion v3 (ed25519) hidden services"
  homepage "https://github.com/cathugger/mkp224o"
  url "https://github.com/cathugger/mkp224o/releases/download/v1.7.0/mkp224o-1.7.0-src.tar.gz"
  sha256 "e38465ea893c6032ddfd7c133cbbf0de2eeaf1c428ca563fac5e85aeb609c929"
  license "CC0-1.0"
  head "https://github.com/cathugger/mkp224o.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "4963af60f493125859687fd0ccdba625997d92d403d90849813a909bd3143a62"
    sha256 cellar: :any,                 arm64_sequoia:  "49b44c366d873465aa731abd4896cbd43d0b4697084cbc2c1b00e69a92ce1d79"
    sha256 cellar: :any,                 arm64_sonoma:   "76a0f038b57586fc90bdb0688520d308e207f11902a9479a81d8149049c9f418"
    sha256 cellar: :any,                 arm64_ventura:  "9251236b842079b87786a0ff3db1b19ff11dba9b78aecf07635842f2494e0ab4"
    sha256 cellar: :any,                 arm64_monterey: "75bccb06af583ad85950b27658b5ffef1c99018b6cf48ec4e190df0c37be4ee7"
    sha256 cellar: :any,                 sonoma:         "fa5df29c3c00e7877e777d3cabb36cd66252c2c952673b542afa3d5102621436"
    sha256 cellar: :any,                 ventura:        "96cb00d8017bbd68a6cb63b75be9f61f009af25139b9be4331fd07a59ceb8936"
    sha256 cellar: :any,                 monterey:       "45a413e61913ebe5fb046527221ae35e7de44d8607e0b4c4c112c06e75dbfd90"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "eedd254c44252b322d95df443fd20f4d7f48d827a0f6cc6f4f1af702e1cd4a3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7614290d244905ffde9a1c969687b56c400aa3d16a272a10ed511d2cd42737af"
  end

  depends_on "libsodium"

  def install
    system "./configure", *std_configure_args
    system "make"
    bin.install "mkp224o"
  end

  test do
    assert_match "waiting for threads to finish...", shell_output("#{bin}/mkp224o -n 3 home 2>&1")
  end
end
