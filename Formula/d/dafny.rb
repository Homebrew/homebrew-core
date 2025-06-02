class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/refs/tags/v4.10.0.tar.gz"
  sha256 "bd643ae9cd5b697505ca3682fa4d15238c6746701eaa1eeba4c541006674da40"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0379afe58205e4e147a773cfe4e45102e4b6bda9a2a40e862641730e23381b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e361b9620dab3bc75b0f55c708fac271c5da152a11aade9873838b52af43c9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72f8fd00da940888a1a2cb7a5ad9ca0919a1537f2b2901336fd21e760f11cc6f"
    sha256 cellar: :any_skip_relocation, ventura:       "a717a33ebf39dcfa1bf658103e5e70d07961643d9652c4823f6969beb47735ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25b428296abab12015268dbdb33f5a15707c5df5754665126cd2a78088b73b27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e7397f8784ded9a6688b1e1a3e5ee31b2278d44e55462429395f1b374b3b736"
  end

  depends_on "gradle" => :build
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
