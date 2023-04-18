class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://ammonite.io/"
  url "https://github.com/com-lihaoyi/Ammonite/releases/download/2.5.8/3.2-2.5.8"
  version "2.5.8"
  sha256 "d5882da5e80cb2cb19c1cf996f1f89a982e1fa0aee80fdb1f383f195a65b1450"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38200fbd6c3f2a67f9d61b32eb5bf75d388d5d88dffaf1d9a3a1cfa54d8a7b76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "891b26612d1e352a4fd518f2772e8d28693a08a3db47971aa9e012762e85b6c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8cb2016a4e1fac0d7c1045ce32e9b5947eae6f450536ccf1a000e8ccfecc2f5"
    sha256 cellar: :any_skip_relocation, ventura:        "15111228713e8c2b5b3481fa9b1031ea4f2e7eff958271da75e2d524dfa5c481"
    sha256 cellar: :any_skip_relocation, monterey:       "6d4531f96f28067de2d7bc1547d0331999f79ed2b0071f3c0b19e273fae5d33b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0784cc0bba17e88d5761bdd323c1e193d9c2c3e046b9f0def8380a1243f398ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb861e42faa7cc5656ff904829d524847b5280b7d0def53cfb00fb5d4e16f093"
  end

  depends_on "openjdk"

  def install
    (libexec/"bin").install Dir["*"].first => "amm"
    chmod 0755, libexec/"bin/amm"
    (bin/"amm").write_env_script libexec/"bin/amm", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"testscript.sc").write <<~EOS
      #!/usr/bin/env amm
      @main
      def fn(): Unit = println("hello world!")
    EOS
    output = shell_output("#{bin}/amm #{testpath}/testscript.sc")
    assert_equal "hello world!", output.lines.last.chomp
  end
end
