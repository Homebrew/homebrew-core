class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "b3f23c9fd7cb13ffa785928ca6a8b61da316564000948ce00eda2ac3d087760a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "400e27e03e51b89dd4c2898b52a26dc23614d1eae927bf19fe3b8bda2cdf0689"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf0071788f21220143ede462f73a3efc0d84859f2860aedcade09067793a2f9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a91553e15fcd64f3e46eaff906228f60e5f16b747e3ccc84157295b98533c8d5"
    sha256 cellar: :any_skip_relocation, ventura:        "e466bcdc357080ea39c1d5ea2161b3d0ef4e034ae1405fd79e4a3ac78c5e262a"
    sha256 cellar: :any_skip_relocation, monterey:       "b1eab1ae0988638e737b556dacb0e3a8ce2235042dcec646d83fb6b0bd5e4492"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c4ba020f8ad3a45db63e5de990aaba17f67ecd14539b61cec697d3bb3f020f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d30205455cc20d5cc7bb4c843dc7f980f3022f6c31cb3d56201755c680781bcb"
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
