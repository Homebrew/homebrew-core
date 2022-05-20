class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/v3.6.0.tar.gz"
  sha256 "c328052f356829325a8e6e128b98ac5c8579cda14b24a43b84e66dece7f774da"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ed130949c9b019c5e6d5c1cc1ec9303212745bd2c533edddcb7f015b7b7b810"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ecfa51f66725940735dd2632823572468744f0d6fe071a08331f9dfdcc64a1b"
    sha256 cellar: :any_skip_relocation, monterey:       "de0c838ff4f374cfcd497789987a384c91e0db2bfbfb77fb358fc99cfe3447ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "5dadb7e6555e0cbc33277f2c4757eda910605d9e8a0c300941f589e50fa975a4"
    sha256 cellar: :any_skip_relocation, catalina:       "939245de03f1a3855c2aa2ce007e866695622e0ffbc1d07b405ed1fbdf2bb42b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e5ab30578934d8c4790aafa8446736e3a740bba4e874228602396725733d6df"
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
      ENV["PYTHON"] = which("python3")
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
