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
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "2cef1302f96a215e8126af9e3ed2c714f7763bbe73b64eb47c68954869cdf350"
    sha256 cellar: :any, arm64_sequoia: "cbcf9f7c69f032ab6ff3a83bad525a86ab607985680870ea905f9fd8d413734b"
    sha256 cellar: :any, arm64_sonoma:  "11b37daadfe93a3be6fe5605b760afbe130d6944100e62f0ceb2b75fce67110d"
    sha256 cellar: :any, arm64_ventura: "dba912fe6c6eb664a0b43092a27e8bb9b9ffab66cea81e559f01bec356eb8265"
    sha256 cellar: :any, sonoma:        "2297f9b535ac16dc443f30f5894772c85c70ec3bb4502b4520d3d93c4ad3ed09"
    sha256 cellar: :any, ventura:       "9a4f63352a659ff766fdd61e5f8dbe71940c024a25f879ff07f75089fe3a19be"
  end

  depends_on :macos

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+

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
    (testpath/"Test.swift").write <<~SWIFT
      import Foundation

      protocol ChildDependency: Dependency {}
      class Child: Component<ChildDependency> {}

      let child = Child(parent: self)
    SWIFT

    assert_match "Root\n", shell_output("#{bin}/needle print-dependency-tree #{testpath}/Test.swift")
    assert_match version.to_s, shell_output("#{bin}/needle version")
  end
end
