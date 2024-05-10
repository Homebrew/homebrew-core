class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "b1da85f4be48179a7131ad32a6b904e7f0c671fd9467cb12cb9959e273c4fc6e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec74acf0b9418e771378c3fdc3f8cff827e2c56b98af165d6120d124d26b41e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1fddb32fb09a9661fc019dd65e84f3a03f8f55c571c58e7d2c48488f85d835a"
    sha256 cellar: :any_skip_relocation, ventura:        "280ca13e956a198e697625bfdcca6398c07aa6a1f84d1424059970e0e175d7ac"
    sha256 cellar: :any_skip_relocation, monterey:       "5bb6f97cd2c12223ac79e3c6426c76a0dafc4e00d2e4c711d580d963416acc56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89f943ade7b3a204f2cd7b0247b0ac2f93ef82aeb782bb71fb676874612cc122"
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
