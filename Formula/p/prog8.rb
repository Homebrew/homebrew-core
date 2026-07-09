class Prog8 < Formula
  desc "Compiled programming language targeting the 8-bit 6502 CPU family"
  homepage "https://prog8.readthedocs.io"
  url "https://github.com/irmen/prog8/archive/refs/tags/v12.2.1.tar.gz"
  sha256 "8cfa17dd5d89b282b6f48124e8b0a3005e94991fc499df76a5d73ac37cc14fa2"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aed1f50903702d3537ad9e034384647147242f14e7b1688b98913d385b67bc1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "861ccb8e6c3272b3f2baf23d08ef42aa837658454e974c54040b755f534351de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61643b3b43adec5701eef4b491273f7b23e02308cbb59009b6ebd2f9b45b4cab"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f9f9c25a2cc2de5c0eed26b1cc807972956218ef2c1b0424b96c98df8b38e36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7d90f93cad25e138b1b8ef1ba6fb9b36a41dc6062b9ffebbfa9e9040b61175f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fe41e022c700f87ec056c2bbdeafcc68d7d94dc1db7884c0332b623b361ef52"
  end

  depends_on "gradle" => :build
  depends_on "kotlin" => :build

  depends_on "openjdk"
  depends_on "tass64"

  def install
    system "gradle", "installDist"

    libexec.install Dir["compiler/build/install/prog8c/*"]
    (bin/"prog8c").write_env_script libexec/"bin/prog8c", JAVA_HOME: formula_opt_prefix("openjdk")
    rm_r(libexec/"bin/prog8c.bat")

    pkgshare.install "examples"
  end

  test do
    system bin/"prog8c", "-target", "c64", "#{pkgshare}/examples/primes.p8"
    assert_match "; 6502 assembly code for 'primes'", (testpath/"primes.asm").readlines.first
  end
end
