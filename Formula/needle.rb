class Needle < Formula
  desc "Compile-time safe Swift dependency injection framework with real code"
  homepage "https://github.com/uber/needle"
  url "https://github.com/uber/needle.git",
      tag:      "v0.17.1",
      revision: "3ac31475379b5a6c18a31436c15d072189e8f5f1"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "c600d106422e22c2930d6fb8a7208995a7d996e06e159a57f6b210a15fbad7ee" => :big_sur
    sha256 "059325b81a187b15fc465fbef99f72892a53ad53016a4b768368e2cd66ae77e4" => :catalina
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
