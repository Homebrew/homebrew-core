class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "7a26b9e8a5f54fb11556201c4a839e04f601e93735a882d7f782191a2c942c56"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db53ec433f8ada834f457aa9452263051035bc90e84edf77b61dd4ac49e8fb55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46bf172d8239c8275249bb80c2291fff1960b752c858739eff3be5cc828db434"
    sha256 cellar: :any_skip_relocation, ventura:        "cd47394361095971eb73890be2ef745081086ecf2d073532c9cdc4e89726f8d4"
    sha256 cellar: :any_skip_relocation, monterey:       "94812f8dc29b343ce991ea9a994ee371da6ee5ac4b717a4f270882541573d2ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b0014f130d7e33690490641f9d4005b1f63daf0a48dbc809c46d9296e7550c3"
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
