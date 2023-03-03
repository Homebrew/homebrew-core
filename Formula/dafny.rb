class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "f1d7fd7f438bc9f7772b4035aa0065d518e62a55711a38822ecadcad4d65e446"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2383b58212856bb2ca74b74d5e04a218ef1bebddad756d6e3be76dae87ea9a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac6d3d07f0b3d1838ba30ca8fe92fd1b877ca4545337599afb1e438c8acc4eab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28c964d69057e55e604f4448de90f6e043e5a9138a89051f4a3c7426b0b5bc8c"
    sha256 cellar: :any_skip_relocation, ventura:        "ddaa7777502f6cb55ac68748d3db2e1b0c0e6f8f0e8f3ae95c4293de367ac498"
    sha256 cellar: :any_skip_relocation, monterey:       "5f2b01d8980629352a836703a85544e7b8478202de19f30333d43c1325c20c76"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0583ef6df65be92d0c84b5f3f75c305adf26ecec970a4a612fcefb6db091707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40824ca81d83b29138ef76bb67c5061ab7e768238e38eb4bf93d75648f7f92bb"
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
        var i: nat;
        assert i as int >= -1;
        print "hello, Dafny\\n";
      }
    EOS
    assert_equal "\nDafny program verifier finished with 1 verified, 0 errors\n",
                  shell_output("#{bin}/dafny /compile:0 #{testpath}/test.dfy")
    assert_equal "\nDafny program verifier finished with 1 verified, 0 errors\nRunning...\n\nhello, Dafny\n",
                  shell_output("#{bin}/dafny /compile:3 #{testpath}/test.dfy")
  end
end
