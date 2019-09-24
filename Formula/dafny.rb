class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://www.microsoft.com/en-us/research/project/dafny-a-language-and-program-verifier-for-functional-correctness"
  url "https://github.com/dafny-lang/dafny/archive/v2.3.0.tar.gz"
  sha256 "ea7ae310282c922772a46a9a85e2b4213043283038b74d012047b5294687d168"

  depends_on "mono-libgdiplus" => :build
  depends_on "nuget" => :build
  depends_on "mono"
  depends_on "z3"

  resource "boogie" do
    url "https://github.com/boogie-org/boogie.git",
      :revision => "9e74c3271f430adb958908400c6f6fce5b59000a"
  end

  def install
    (buildpath/"../boogie").install resource("boogie")
    cd buildpath/"../boogie" do
      system "nuget", "restore", "Source/Boogie.sln"
      system "msbuild", "Source/Boogie.sln"
    end
    system "msbuild", "Source/Dafny.sln"

    libexec.install Dir["Binaries/*"]
    (libexec/"z3/bin").install_symlink which("z3")

    (bin/"dafny").write <<~EOS
      #!/bin/bash
      mono #{libexec}/dafny.exe "$@"
    EOS
  end

  test do
    (testpath/"test.dfy").write <<~EOS
      method Main() {
        print "hello, Dafny\\n";
      }
    EOS
    system "#{bin}/dafny", testpath/"test.dfy"
  end
end
