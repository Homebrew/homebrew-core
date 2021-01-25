class Needle < Formula
  desc "Compile-time safe Swift dependency injection framework with real code"
  homepage "https://github.com/uber/needle"
  url "https://github.com/uber/needle.git",
      tag:      "v0.17.1",
      revision: "3ac31475379b5a6c18a31436c15d072189e8f5f1"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "d1b4c382f90fb980a40f4d04c7fb4f6c7afb9024b453731dbaf2a24cc974fd76" => :big_sur
    sha256 "b66f209a2d40070653cc38d2910ffb0c2810ceaf4fb9daa39dbab3b46d185ad3" => :arm64_big_sur
    sha256 "3d62dba1647de4fb3d967bf42435eb4009d3eedc760d3d69e87ba9be17315681" => :catalina
  end

  depends_on xcode: ["12.2", :build]

  def install
    system "make", "install", "BINARY_FOLDER_PREFIX=#{prefix}"
    bin.install "./Generator/bin/needle"
    libexec.install "./Generator/bin/lib_InternalSwiftSyntaxParser.dylib"
  end

  test do
    (testpath/"Test.swift").write <<~EOS
      import Foundation

      protocol ChildDependency: Dependency {}
      class Child: Component<ChildDependency> {}

      let child = Child(parent: self)
    EOS

    assert_match "Root\n", shell_output("#{bin}/needle print-dependency-tree #{testpath}/Test.swift")
    assert_match version.to_s, shell_output("#{bin}/needle version")
  end
end
