class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "8536bc0650e3801cfb21bd0fc65d2c802940917eb572719d0695c763765c2ea0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6eb44308a714f0b2c221e787cedabf9d661cc34a606ebac173005ca7e5bb78a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bd82566ad4184a2fcc0c592cba9cb33cd8b9639f49a4b67c7b386393ef2f7e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "699d4be5f1d69325f318fe989dd5133c280fbabd82036426fe534d421237ca5f"
    sha256 cellar: :any_skip_relocation, ventura:        "63507aab19b4de2187220e9bd4274dfa68c1bda032f75020899f5d8b4a0e97a3"
    sha256 cellar: :any_skip_relocation, monterey:       "c491d234a7d6e1539aca1f2c6b7bd7894635295ac86b8a02165c4c1672b79177"
    sha256 cellar: :any_skip_relocation, big_sur:        "9221a7a330861ab88a42f11e799e5960fa13403d063ad60ad004d4f972d7fadc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d99b8fee1bc448013011e421602b3d68629842f878765c29fcfcbcd9aff18a8a"
  end

  depends_on "dotnet@6"
  # We use the latest Java version that is compatible with gradlew version in `dafny`.
  # https://github.com/dafny-lang/dafny/blob/v#{version}/Source/DafnyRuntime/DafnyRuntimeJava/gradle/wrapper/gradle-wrapper.properties
  # https://docs.gradle.org/current/userguide/compatibility.html
  depends_on "openjdk@17"

  uses_from_macos "python" => :build, since: :catalina # for z3

  # Use the following along with the z3 build below, as long as dafny
  # cannot build with latest z3 (https://github.com/dafny-lang/dafny/issues/3601)
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
