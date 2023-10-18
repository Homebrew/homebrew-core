class Koka < Formula
  desc "Compiler for the Koka language"
  homepage "http://koka-lang.org"
  url "https://github.com/koka-lang/koka.git",
    tag:      "v2.4.2",
    revision: "0649baaa2a4509c0a5adb743b6f2b5f1ef32a5a9"
  license "Apache-2.0"
  head "https://github.com/koka-lang/koka.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e962c3454bd9096b74967fbfac58f5931776dd54bdbc9328191c937c644b3bfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8588e92041cc5a02996c3c09cb7e69dc4262d0268a35885855e69957de63a2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fffa3b7ad9a67005f9d3bd3523bc9a8194b58d24b15f2451cf9dde23bb721e95"
    sha256 cellar: :any_skip_relocation, sonoma:         "0815510142c00ee7917e97c4b592fb1b70ad07ef4a993af2ae374f2d080b343a"
    sha256 cellar: :any_skip_relocation, ventura:        "c96bc9638a6abc21780d34dd83970a46874fd7ee733ce12cd06dee0e3fd2d30d"
    sha256 cellar: :any_skip_relocation, monterey:       "19070bd018677993cb0641c79379cb63b57393d0103598d08520d3e5ef92c826"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "139adefa77ae0b43b1d48161695cc7633c627c524f7a7794e8fc3d17f421f249"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.4" => :build
  depends_on "pcre2" => :build

  def install
    system "cabal", "update"
    system "cabal", "build", "-j"
    system "cabal", "run", "koka", "--",
           "-e", "util/bundle.kk", "--",
           "--prefix=#{prefix}", "--install"
  end

  test do
    (testpath/"hellobrew.kk").write('pub fun main() println("Hello Homebrew")')
    assert_match "Hello Homebrew", shell_output("#{bin}/koka -e hellobrew.kk")
    assert_match "420000", shell_output("#{bin}/koka -O2 -e samples/basic/rbtree")
  end
end
