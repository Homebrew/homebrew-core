class Needle < Formula
  desc "Compile-time safe Swift dependency injection framework with real code"
  homepage "https://github.com/uber/needle"
  url "https://github.com/uber/needle/archive/v0.22.0.tar.gz"
  sha256 "25e9c37ea2bdf1a42ba183eb34ac4907ca68732332d1e5f7ce193263ac619af2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "50f420dc1d5156e6176f032e22fa6fcbb4f35ee51629d2d26e6e4264b82153a9"
    sha256 cellar: :any, arm64_monterey: "7ab5cad2f46682955e752e111255b59e2ccd9b1d8d63416546cbbbdc4be1c035"
    sha256 cellar: :any, ventura:        "aab548a4703d004d698ffe28b72784ea31637650db3100931ca59efbe8999c23"
    sha256 cellar: :any, monterey:       "cd0d8cf19cc7bdd4a39e8f8557a76f03b93ea00377a9e91036dddcd2fd19f802"
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
