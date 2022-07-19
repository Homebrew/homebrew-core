class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/v3.7.3.tar.gz"
  sha256 "a56fba9687d5375353fc0bdb3c6df9fed19b365720e95f7c78fb92d2ab462f71"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5db74437b97b2c768e248c9aad18db077a518652c1c49ba445db4c53e41172ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd4100c72a83ca3bf0339f9cf7b6ad6618c04b434fae287695da31ceb4b09037"
    sha256 cellar: :any_skip_relocation, monterey:       "44ef50af57570ab99091395c203cae654b56ff61169f1b770ceaa90b32de7752"
    sha256 cellar: :any_skip_relocation, big_sur:        "c36f761d5bb103560db21805afdff2abf5841885cb0b4ad151293dade88147db"
    sha256 cellar: :any_skip_relocation, catalina:       "2abe9b989b1c6aae2d65385c36091cb4dea51d3fb413394efd492fbdc3904e7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96a363f23dbcbfe901c657a069cfa5ef9f066eade3f832dfca01616b7f0e5813"
  end

  depends_on "gradle" => :build
  depends_on "python@3.10" => :build # for z3
  depends_on "dotnet"
  depends_on "openjdk@11"

  # Use the following along with the z3 build below, as long as dafny
  # cannot build with latest z3 (https://github.com/dafny-lang/dafny/issues/810)
  resource "z3" do
    url "https://github.com/Z3Prover/z3/archive/Z3-4.8.5.tar.gz"
    sha256 "4e8e232887ddfa643adb6a30dcd3743cb2fa6591735fbd302b49f7028cdc0363"
  end

  def install
    system "make", "exe"

    libexec.install Dir["Binaries/*", "Scripts/quicktest.sh"]

    dst_z3_bin = libexec/"z3/bin"
    dst_z3_bin.mkpath

    resource("z3").stage do
      ENV["PYTHON"] = which("python3")
      system "./configure"
      system "make", "-C", "build"
      mv("build/z3", dst_z3_bin/"z3")
    end

    (bin/"dafny").write <<~EOS
      #!/bin/bash
      dotnet #{libexec}/Dafny.dll "$@"
    EOS
  end

  test do
    (testpath/"test.dfy").write <<~EOS
      method Main() {
        var i: nat;
        assert i as int >= -1;
        print "hello, Dafny\\n";
      }
    EOS
    assert_equal "\nDafny program verifier finished with 1 verified, 0 errors\n",
                  shell_output("#{bin}/dafny /compile:0 #{testpath}/test.dfy")
    assert_equal "\nDafny program verifier finished with 1 verified, 0 errors\nRunning...\n\nhello, Dafny\n",
                  shell_output("#{bin}/dafny /compile:3 #{testpath}/test.dfy")
    assert_equal "Z3 version 4.8.5 - 64 bit\n",
                 shell_output("#{libexec}/z3/bin/z3 -version")
  end
end
