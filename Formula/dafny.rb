class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/refs/tags/v3.9.0.tar.gz"
  sha256 "0f35d6cca664f53fcdd52a4805757abbc96890937de101700f1a6cd99eee4579"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db1c4b783d4cf1177fd82f265fd96c1bb76e24dba4cfb1c60e0764c8e7bbe186"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82410cc7e460087a94476b01114cf6dbfc3cd8246066ffc87fc08799442b6784"
    sha256 cellar: :any_skip_relocation, monterey:       "31dece4a7041ea91a713861f8186d379f511ab4fe2efa4d1a4b9d9e7eeb63b16"
    sha256 cellar: :any_skip_relocation, big_sur:        "1bbe16cd800e0d5ea4a8bf07ed9f046cb02f7cb557dc584cf62a87a66021a3ac"
    sha256 cellar: :any_skip_relocation, catalina:       "b93ba447cf523bf14c4ce8533a8a1612cd4d9be3c6465ebbd1a1a84642273dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf9bab5a0efd0430dd23c69f9de919596e221e4c644a8780f161204122dfd029"
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
