class Needle < Formula
  desc "Compile-time safe Swift dependency injection framework with real code"
  homepage "https://github.com/uber/needle"
  url "https://github.com/uber/needle.git",
      tag:      "v0.17.0",
      revision: "a45fb8f4571cab3fe0a57b03f271ba6d10e62cc1"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "a76234c9daaee111f6c29cd25e7ae81f2941a0a967e2d1768e05e050e2e263e0" => :big_sur
    sha256 "aa5b5f934e831d61d2d623324a48b0e47cab4de498e643fbbce2c52d9c060f0e" => :catalina
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
