class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "02608ab5047b308924682faa0b8fe7a502455a7d331e46dd0f7e8cd8ab832f22"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d40afa1783242864a8488096939539baf56680b558f5f8a0694e51456e1e003b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "361fd1ba0602ddf4a2817401ab3dc21f8cacf76285f567e660d2e01a0b61b113"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ae0acbf8ff24370d1e1a912a48dbcb50e38fdc8455b269ae4240c49a405b6e6"
    sha256 cellar: :any_skip_relocation, ventura:        "6e1e360e78a434ae661b30c5114a69dce77aa8326b203af4d0b066b5ef36ced8"
    sha256 cellar: :any_skip_relocation, monterey:       "268edd00eb8d5e49031b19e3ef2cc26790d933a1aa081a131f3cd4a5c39c1825"
    sha256 cellar: :any_skip_relocation, big_sur:        "a80088368fda196c31f2cef1877a0338ccddc81cccc082821aeaff9694812669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7135957185c1b298da0cc635c5daa624d979c419a2d9eb20e047cc54bcf74aa4"
  end

  depends_on "dotnet@6"
  # We use the latest Java version that is compatible with gradlew version in `dafny`.
  # https://github.com/dafny-lang/dafny/blob/v#{version}/Source/DafnyRuntime/DafnyRuntimeJava/gradle/wrapper/gradle-wrapper.properties
  # https://docs.gradle.org/current/userguide/compatibility.html
  depends_on "openjdk@17"

  uses_from_macos "python" => :build, since: :catalina # for z3

  # Use the following along with the z3 build below, as long as dafny
  # cannot build with latest z3 (https://github.com/dafny-lang/dafny/issues/810)
  resource "z3" do
    url "https://github.com/Z3Prover/z3/archive/Z3-4.8.5.tar.gz"
    sha256 "4e8e232887ddfa643adb6a30dcd3743cb2fa6591735fbd302b49f7028cdc0363"
  end

  def install
    system "make", "exe"
    libexec.install Dir["Binaries/*", "Scripts/quicktest.sh"]

    resource("z3").stage do
      ENV["PYTHON"] = which("python3")
      system "./configure"
      system "make", "-C", "build"
      (libexec/"z3/bin").install "build/z3"
    end

    (bin/"dafny").write <<~EOS
      #!/bin/bash
      exec "#{Formula["dotnet@6"].opt_bin}/dotnet" "#{libexec}/Dafny.dll" "$@"
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
