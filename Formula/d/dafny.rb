class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/refs/tags/v4.7.0.tar.gz"
  sha256 "f18f0f92ec00d5ab743bdaf0208fc1487a52e948ca72720b2bbc34374f812ba8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bae2544ebaafc7cac9549020796c676fcf7a1ecd252fa6e71777f07a541a0d61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "020a5fb249da8a8ee49cbe96d5da92b7a816be5c7181a0f5bc0e628323601544"
    sha256 cellar: :any_skip_relocation, ventura:        "82cff5f5ba66d21f6d53666e122808436c727ccac2e3647c90a2f0303f2a5a34"
    sha256 cellar: :any_skip_relocation, monterey:       "706f29051c0fc967745e62f901049e9d5f9b82884d2c7c4aa0b1354171cdf7a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0358dbc8e9c76c3cc0100212424cfc65cf5e4b872ba28e2c1ca5a7c0a11d0e0"
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
