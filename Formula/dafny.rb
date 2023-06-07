class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "63f9cf593efb1c1c75d3083d9b207f572839efba381af21cdab958ab127366c4"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "644c887223e4a194e4f4b41ee3635b77abd57f0506e7d916b54cd268eae2b185"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfa05d4dbb73223f4b50524eb9e86104a384f5fe1e6aa46ae7f3443903d7a12f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53df70ee58e7bce7e592ffcb561b75851a9a60876ae9b79950f246b387e6f35d"
    sha256 cellar: :any_skip_relocation, ventura:        "c60e9640f0abdb93ff8129c6d0a5fe476737f11bb321b6740cd7de2a901746e1"
    sha256 cellar: :any_skip_relocation, monterey:       "995a1ab1f4e59cc601b24ff8338f92235a37f1dd4d810302d1c2420983f1b699"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccf24904424c7834c9b04605facfb927c9e732da22a593b34bcdc6d2713eca67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91d52605ebe3500df22f22964ac2cf1bbc76fd3fac9c4403c25ce89b1ff757f1"
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
