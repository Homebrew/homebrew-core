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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2de46d77301715659320ec274aac3671c8928f0f2824a951f31dc418e97c5e34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75f863b4a43115317619842091f9e7116faa7630fea34e6a6cd13a201051f212"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4e362ed36030cbddac3a806d1d535b1d7e0952425e4eea1b33e12da945c3e5e"
    sha256 cellar: :any_skip_relocation, ventura:        "42446815acf78d6cc88546a90bef29a323adb7f3617a7c1d4548db9367dd6132"
    sha256 cellar: :any_skip_relocation, monterey:       "78ee7cc7c13f89cdd86ef6b8991b794d5834ce13ada79e1be7cce2833b3f751e"
    sha256 cellar: :any_skip_relocation, big_sur:        "dff060e112f2c71f27f81e5475259fa7654091ee527d1b93cc79f64dced4bddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bebceea164d81e2b4669ede2bad7447c63aae2f771cd1b8f502353254f871a6"
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
