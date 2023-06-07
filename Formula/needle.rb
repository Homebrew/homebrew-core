class Needle < Formula
  desc "Compile-time safe Swift dependency injection framework with real code"
  homepage "https://github.com/uber/needle"
  url "https://github.com/uber/needle/archive/v0.23.0.tar.gz"
  sha256 "d1560e078ef79d219fd9c03575b572fd2bfd57367b25251b38d66f1dd9cd8359"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "9d36075eb688cbb3bc7ee5c8ce3842059f6633d1a9651a19203540832be0781b"
    sha256 cellar: :any, arm64_monterey: "582013f3c319c53d9e890417a421614191c25967a5e0210f98f6e77a517ae28c"
    sha256 cellar: :any, ventura:        "89a92a4e64b6356e56fac67816f6dd7b6f351dbc49c257102ff9dece34f022cd"
    sha256 cellar: :any, monterey:       "ed684d01c9d0284002e201806ea57df88ab25ba750f9a7669d10d40c695831ef"
  end

  depends_on xcode: ["14.0", :build]
  depends_on :macos

  def install
    # Avoid building a universal binary.
    swift_build_flags = (buildpath/"Makefile").read[/^SWIFT_BUILD_FLAGS=(.*)$/, 1].split
    %w[--arch arm64 x86_64].each do |flag|
      swift_build_flags.delete(flag)
    end

    system "make", "install", "BINARY_FOLDER_PREFIX=#{prefix}", "SWIFT_BUILD_FLAGS=#{swift_build_flags.join(" ")}"
    bin.install "./Generator/bin/needle"
    libexec.install "./Generator/bin/lib_InternalSwiftSyntaxParser.dylib"

    # lib_InternalSwiftSyntaxParser is taken from Xcode, so it's a universal binary.
    deuniversalize_machos(libexec/"lib_InternalSwiftSyntaxParser.dylib")
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
