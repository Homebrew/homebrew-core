class Needle < Formula
  desc "Compile-time safe Swift dependency injection framework with real code"
  homepage "https://github.com/uber/needle"
  url "https://github.com/uber/needle/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "b9cf878b0ce9589e862ec5aa8ba3222e181ecbe038369989d2ee9d9c80157fbb"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "36eefd947c51d41c2aeefa29f104523888e0f61110dcdae01dee53be5726d24e"
    sha256 cellar: :any, arm64_sonoma:  "ee257a4ef13ec18eda8c54354fc67c2bd78d3b5686cbc0a0e9c9c3607fa7e2cd"
    sha256 cellar: :any, sonoma:        "60f50b3285a36d440c5af05abf77d61ef2a7b9f8a897099b67a9fc2f8d97d014"
  end

  depends_on xcode: ["15.3", :build]
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
