class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://www.microsoft.com/en-us/research/project/dafny-a-language-and-program-verifier-for-functional-correctness"
  url "https://github.com/dafny-lang/dafny/archive/v2.3.0.tar.gz"
  sha256 "ea7ae310282c922772a46a9a85e2b4213043283038b74d012047b5294687d168"

  bottle do
    cellar :any_skip_relocation
    sha256 "73faff043056b7e45842d6c528a530d4ce4f5072f92ed7612cdd458d64de2985" => :catalina
    sha256 "c0a0e194956400b852678cddfd8f9135ccdb8fd1949dc24611d0a37ec9b5640a" => :mojave
    sha256 "2bf8cf46f3233236273c8cfdec90e7f8168fc160342ac36a0c6bc8f22f57559b" => :high_sierra
  end

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
