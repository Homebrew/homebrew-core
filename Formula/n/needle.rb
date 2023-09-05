class Needle < Formula
  desc "Compile-time safe Swift dependency injection framework with real code"
  homepage "https://github.com/uber/needle"
  url "https://github.com/uber/needle/archive/v0.24.0.tar.gz"
  sha256 "61b7259a369d04d24c0c532ecf3295fdff92e79e4d0f96abaed1552b19208478"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "2b953b5225793b663e30652c4dcf15af21883f3161e1424cf3ae4884def4fc85"
    sha256 cellar: :any, arm64_monterey: "f5336518cc424b2a5daf3400d9968035966226f1372d75ad4e8d950a5bfced93"
    sha256 cellar: :any, ventura:        "4a2e37bdcfa6fd09d7a6115ef0d61ed067f6c32ff336513a0e48efc7ce4e502c"
    sha256 cellar: :any, monterey:       "0a7abfa75a75acf3773fc1bef1ed9e268ddda7da6ceafb2c5f74c6d36a4922c8"
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
