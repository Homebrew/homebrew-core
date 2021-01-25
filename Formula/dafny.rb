class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/v2.3.0.tar.gz"
  sha256 "ea7ae310282c922772a46a9a85e2b4213043283038b74d012047b5294687d168"
  license "MIT"
  revision 3

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "67bef401bfee4518789c1a12e72beeaeb7359d8c4d388dc89ab7427b4136e9ef" => :big_sur
    sha256 "3c73b8c0c0f1b204f1118ef40c857418e112f6c5aac3c299d1be3abefce1704f" => :catalina
    sha256 "3a21de05e53a0276a2aaaf3e82f2f8062b02ae9e31ba2a7bd0b2631691d10eca" => :mojave
  end

  depends_on "mono-libgdiplus" => :build
  depends_on "nuget" => :build
  depends_on "mono"

  resource "boogie" do
    url "https://github.com/boogie-org/boogie.git",
        revision: "9e74c3271f430adb958908400c6f6fce5b59000a"
  end

  # Use the following along with the z3 build below, as long as dafny
  # cannot build with latest z3 (https://github.com/dafny-lang/dafny/issues/810)
  resource "z3" do
    url "https://github.com/Z3Prover/z3/archive/z3-4.8.4.tar.gz"
    sha256 "5a18fe616c2a30b56e5b2f5b9f03f405cdf2435711517ff70b076a01396ef601"
  end

  def install
    (buildpath/"../boogie").install resource("boogie")
    cd buildpath/"../boogie" do
      system "nuget", "restore", "Source/Boogie.sln"
      system "msbuild", "Source/Boogie.sln"
    end
    system "msbuild", "Source/Dafny.sln"

    libexec.install Dir["Binaries/*"]

    dst_z3_bin = libexec/"z3/bin"
    dst_z3_bin.mkpath

    resource("z3").stage do
      system "./configure"
      system "make", "-C", "build"
      mv("build/z3", dst_z3_bin/"z3")
    end

    (bin/"dafny").write <<~EOS
      #!/bin/bash
      mono #{libexec}/dafny.exe "$@"
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
                  shell_output("#{bin}/dafny /nologo /compile:0 #{testpath}/test.dfy")
    assert_equal "\nDafny program verifier finished with 1 verified, 0 errors\nRunning...\n\nhello, Dafny\n",
                  shell_output("#{bin}/dafny /nologo /compile:3 #{testpath}/test.dfy")
    assert_equal "Z3 version 4.8.4 - 64 bit\n",
                 shell_output("#{libexec}/z3/bin/z3 -version")
  end
end
