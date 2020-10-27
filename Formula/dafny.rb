class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://github.com/dafny-lang/dafny/archive/v2.3.0.tar.gz"
  sha256 "ea7ae310282c922772a46a9a85e2b4213043283038b74d012047b5294687d168"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "00cfdeb5892e2834b144a6e4c816a50d594440882327e65a771f9e72cd13f82d" => :catalina
    sha256 "4b0bb8f5e2385b99318cc85ff38496e87814d5658f5dd4054fdc7d2a0a8ebc07" => :mojave
    sha256 "4b64f7c46ab2fdfb997ca918c81e0d423609f565bdd405eaa9a2d7e848295ab7" => :high_sierra
  end

  depends_on "mono-libgdiplus" => :build
  depends_on "nuget" => :build
  depends_on "mono"
  depends_on "z3"

  resource "boogie" do
    url "https://github.com/boogie-org/boogie.git",
      revision: "9e74c3271f430adb958908400c6f6fce5b59000a"
  end

  def install
    (buildpath/"../boogie").install resource("boogie")
    cd buildpath/"../boogie" do
      system "nuget", "restore", "Source/Boogie.sln"
      system "msbuild", "Source/Boogie.sln"
    end
    system "msbuild", "Source/Dafny.sln"

    libexec.install Dir["Binaries/*"]

    # We don't want to resolve opt_bin here.
    dst_z3_bin = libexec/"z3/bin"
    dst_z3_bin.mkpath
    ln_sf (Formula["z3"].opt_bin/"z3").relative_path_from(dst_z3_bin), dst_z3_bin/"z3"

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
