class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/refs/tags/v3.8.1.tar.gz"
  sha256 "901b7e39dec8ac96159f32ac2fc8d795c3908d37788c80ce736754d4b6e142b4"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28ae36d8b02dfbdf1278286c5573ef39c2cd87c62320e8b420f0f7b53fd3a82f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5126542ebdb6a739d510e3ef2428faa780f80bd344c434d504bcf8c3dea91eef"
    sha256 cellar: :any_skip_relocation, monterey:       "277da0d24e564809ac47eb2dbc11cc8f38614300f70ce7bc32243a6fb16f3fa8"
    sha256 cellar: :any_skip_relocation, big_sur:        "551ef73b92c418ede02b4847ad544490cf3cbb2158ea3b0235325106500660ec"
    sha256 cellar: :any_skip_relocation, catalina:       "0a1516c97d4d4d08b17b3a38415b51485fe953c666acd9b0adb1dbe96adf5fa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d64ba218701542afd0e306251df60f924ddb92e12d022328086e247fc3f6282"
  end

  depends_on "gradle" => :build
  depends_on "python@3.10" => :build # for z3
  depends_on "dotnet"
  depends_on "openjdk@11"

  # Use the following along with the z3 build below, as long as dafny
  # cannot build with latest z3 (https://github.com/dafny-lang/dafny/issues/810)
  resource "z3" do
    url "https://github.com/Z3Prover/z3/archive/Z3-4.8.5.tar.gz"
    sha256 "4e8e232887ddfa643adb6a30dcd3743cb2fa6591735fbd302b49f7028cdc0363"
  end

  def install
    system "make", "exe"

    libexec.install Dir["Binaries/*", "Scripts/quicktest.sh"]

    dst_z3_bin = libexec/"z3/bin"
    dst_z3_bin.mkpath

    resource("z3").stage do
      ENV["PYTHON"] = which("python3.10")
      system "./configure"
      system "make", "-C", "build"
      mv("build/z3", dst_z3_bin/"z3")
    end

    (bin/"dafny").write <<~EOS
      #!/bin/bash
      dotnet #{libexec}/Dafny.dll "$@"
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
    assert_equal "Z3 version 4.8.5 - 64 bit\n",
                 shell_output("#{libexec}/z3/bin/z3 -version")
  end
end
