class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/refs/tags/v4.11.0.tar.gz"
  sha256 "05417a2250cea13494318a60d86bd0dc6d9622bd625d9f4fbeb42854462e6798"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e05c17dd373fc4990bfdbb912d8fa47eb1981a5fd34ec150283f53eddaa0c9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "296346300fcb84014e88bcd5e6a43a3f59c1f5b90f6c4f9c9ff5e6664459f104"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "399f9dc444e83573e736e553df66faeb0c492abe5efc5d547c64b6f5732825e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "212a957c6cff6a2b3709544c5ed25d75231aa25cd7c46f0dd2b4b7407add8b8f"
    sha256 cellar: :any_skip_relocation, ventura:       "531c8d8608f45143c240ebcdb7c7bc92a47cf23d20b972f9d0d435318198a569"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61c5799971f66478103d85b42562172496531a3aa2e8e8566befc75079bb7154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af77022b146755d7d3504323a153d62fd2d234fd23b831884555d1d6a037e16f"
  end

  # Upstream uses v8 and v9 is not yet compatible
  depends_on "gradle@8" => :build
  depends_on "openjdk" => [:build, :test]

  depends_on "dotnet@8"
  depends_on "z3"

  def install
    # Use our `gradle` to build rather than wrapper which uses its own copy
    rm("Source/DafnyRuntime/DafnyRuntimeJava/gradlew")
    inreplace "Source/DafnyRuntime/DafnyRuntime.csproj", 'Command="./gradlew ', 'Command="gradle '

    system "make", "exe"
    libexec.install Dir["Binaries/*", "Scripts/quicktest.sh"]

    (bin/"dafny").write <<~EOS
      #!/bin/bash
      exec "#{Formula["dotnet@8"].opt_bin}/dotnet" "#{libexec}/Dafny.dll" "$@"
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

    ENV["JAVA_HOME"] = Language::Java.java_home
    assert_match(/^\nDafny program verifier finished with 1 verified, 0 errors\n(.*\n)*hello, Dafny\n$/,
                 shell_output("#{bin}/dafny run --target:java #{testpath}/test.dfy"))
  end
end
