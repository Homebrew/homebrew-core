class Prog8 < Formula
  desc "Compiled programming language targeting the 8-bit 6502 CPU family"
  homepage "https://prog8.readthedocs.io"
  url "https://github.com/irmen/prog8/archive/refs/tags/v11.4.1.tar.gz"
  sha256 "a1d2dfd962d4919075472235f11fd06aa4b07f3b91ca0f9fb1ef5b8593907ab4"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68ce0b74ba490aef44454b33b8221ad0e335570395b29c0f428287e276a055f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f4a669c0fc9201cb272b01b57daac522ab9b92596f2a1d1ef454f1c82c7b018"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d0e7a40e01fa2f9834773f50bad5d585e2e65d3feaa7ec73bbff359397203ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd92a487b7018f9708b811f302a6de44f01323bed5f1c2f7447baa7b830a7c15"
    sha256 cellar: :any_skip_relocation, sonoma:        "14ca83ff9ca7cc7563514d5a43441998d9fe9bbdb148a29422223e3e3bd687e0"
    sha256 cellar: :any_skip_relocation, ventura:       "f722698eec16f7873de512ff8f8f45419eff863bbd81ca324a39150c959ece13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdfd39ecd1a7ec2ccb57cb7120ea07f6f5a1274fcff40fcf2ff7df0f9bba5f8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bd4f3b4d848521fcd2d8ce102e0f9b1c5101f0b362c7f516dbeb9582038fda3"
  end

  depends_on "gradle" => :build
  depends_on "kotlin" => :build

  depends_on "openjdk"
  depends_on "tass64"

  def install
    system "gradle", "installDist"

    libexec.install Dir["compiler/build/install/prog8c/*"]
    (bin/"prog8c").write_env_script libexec/"bin/prog8c", JAVA_HOME: Formula["openjdk"].opt_prefix
    rm_r(libexec/"bin/prog8c.bat")

    pkgshare.install "examples"
  end

  test do
    system bin/"prog8c", "-target", "c64", "#{pkgshare}/examples/primes.p8"
    assert_match "; 6502 assembly code for 'primes'", File.open(testpath/"primes.asm").first
  end
end
