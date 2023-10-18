class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "f5cb71b3ea0ee0008291cf48540797f62d336f01330e8e519329dcdd1e78ce92"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94e5c99f96e61b34bd0fbf4ae0911ed51494331cfeb0a371ac7d72a003798173"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b144d10a4b6d837d95935d61542ce099144b6ef04862f2d37daf9f7074095e5c"
    sha256 cellar: :any_skip_relocation, ventura:        "b5c1248f3838792406c6eb24c80af33adf91a37da832bddd5b672650e0da062e"
    sha256 cellar: :any_skip_relocation, monterey:       "8b7ad20eca0adc568b453dbdc8e6c34e512c0d630953c8bd48013a5d1853658d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f36f301181e63c313fe4d805c8fd5524e6eccfd2086f2c50c9571f0e7134c1f3"
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
