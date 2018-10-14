class Pasdoc < Formula
  desc "Documentation tool for ObjectPascal (FP, Lazarus, Delphi) source code"
  homepage "https://github.com/pasdoc/pasdoc/wiki"
  url "https://github.com/pasdoc/pasdoc/archive/v0.15.0.tar.gz"
  sha256 "9863c56a199d12bfc22f2ff06d387831e01f052a59c5ad087717756d9193ed6d"
  head "https://github.com/pasdoc/pasdoc.git"
  depends_on "fpc" => :build

  def install
    system "make", "build-fpc-default"
    bin.install Dir["bin/*"]
  end

  test do
    hello = <<~EOS
      program Hello;
      uses GL;
      begin
        writeln('Hello Homebrew')
      end.
    EOS
    (testpath/"hello.pas").write(hello)
    system "#{bin}/pasdoc", "--format=html", "hello.pas"
    assert_path_exist(testpath/"Hello.html")
  end
end
