class Needle < Formula
  desc "Compile-time safe Swift dependency injection framework with real code"
  homepage "https://github.com/uber/needle"
  url "https://github.com/uber/needle.git",
      tag:      "v0.16.2.2",
      revision: "1f8f8bce6a8b13106f8c679518ae96b03defc093"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "a76234c9daaee111f6c29cd25e7ae81f2941a0a967e2d1768e05e050e2e263e0" => :big_sur
    sha256 "aa5b5f934e831d61d2d623324a48b0e47cab4de498e643fbbce2c52d9c060f0e" => :catalina
  end

  depends_on xcode: ["11.6", :build]

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
