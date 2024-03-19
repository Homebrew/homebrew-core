class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "16fbb3ab58b1e134888e9c1870c21596de096e2343e2d1e4dac92eb133e5d709"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82da952f859be276293a2aa78adb35525069d42b62abcdd5b36154600d157f79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6d09b23732c6cee2d3722e3a4e76ba4996239edc0470a01fddc8969738fb1fb"
    sha256 cellar: :any_skip_relocation, ventura:        "5944c263e072071d4da4f3a3d33e7a1d655d1f69f5936e094b474ff5119f6cf4"
    sha256 cellar: :any_skip_relocation, monterey:       "97fb3aa48d29a64e4a55c5761b3e4ac9031646cdec10ec20e0049ebd6fad0bda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "256789e5f23cd1e67f8cce25fc648aa87ac54164e3b14f328edaf93f233d2304"
  end

  depends_on "dotnet@6"
  # We use the latest Java version that is compatible with gradlew version in `dafny`.
  # https://github.com/dafny-lang/dafny/blob/v#{version}/Source/DafnyRuntime/DafnyRuntimeJava/gradle/wrapper/gradle-wrapper.properties
  # https://docs.gradle.org/current/userguide/compatibility.html
  depends_on "openjdk@17"
  depends_on "z3"

  def install
    system "make", "exe"
    libexec.install Dir["Binaries/*", "Scripts/quicktest.sh"]

    (bin/"dafny").write <<~EOS
      #!/bin/bash
      exec "#{Formula["dotnet@6"].opt_bin}/dotnet" "#{libexec}/Dafny.dll" "$@"
    EOS
  end

  test do
    (testpath/"test.dfy").write <<~EOS
      method Main() {
        var i: nat :| true;
        assert i as int >= -1;
        print "hello, Dafny\\n";
      }
    EOS
    assert_equal "\nDafny program verifier finished with 1 verified, 0 errors\n",
                  shell_output("#{bin}/dafny verify #{testpath}/test.dfy")
    assert_equal "\nDafny program verifier finished with 1 verified, 0 errors\nhello, Dafny\n",
                  shell_output("#{bin}/dafny run #{testpath}/test.dfy")
  end
end
