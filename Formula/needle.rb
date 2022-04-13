class Needle < Formula
  desc "Compile-time safe Swift dependency injection framework with real code"
  homepage "https://github.com/uber/needle"
  url "https://github.com/uber/needle.git",
      tag:      "v0.18.1",
      revision: "bf2d46c461476fec7398f3b6a7bb70556e6925f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1929735212f6d3ee84ac3019cd82d4b76e352f780e68f22e381a44e687ae59a0"
    sha256 cellar: :any, big_sur:       "efd84a4bd0890a28c3b9e7d2d9ac9b84a8f4d6bb6a0586380f4d653a6092e52a"
    sha256 cellar: :any, catalina:      "f45fa77b9e00be408206fc2cf945f41ca3f4661bbb06c8d2aadd015f4d75dfdd"
  end

  depends_on "swift" => :build # for copying lib_InternalSwiftSyntaxParser.dylib

  def install
    # Install lib_InternalSwiftSyntaxParser.dylib from swift formula to guarantee
    # an open-source copy as opposed to copying from Xcode.app toolchain
    inreplace "Makefile", "$(XCODE_PATH)/Toolchains/XcodeDefault.xctoolchain",
                          Formula["swift"].opt_prefix.glob("Swift-*.xctoolchain").first

    system "make", "install", "BINARY_FOLDER_PREFIX=#{prefix}",
                              "SWIFT_BUILD_FLAGS=--disable-sandbox -c release"
    bin.install "Generator/bin/needle"
    libexec.install "Generator/bin/lib_InternalSwiftSyntaxParser.dylib"
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
