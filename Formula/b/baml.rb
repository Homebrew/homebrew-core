class Baml < Formula
  desc "Programming language for agents"
  homepage "https://boundaryml.com/"
  url "https://github.com/BoundaryML/baml/archive/refs/tags/baml-wrapper-0.2.5.tar.gz"
  sha256 "f1539402dfeb4cfd6b4b14f4b21e5b290eb6fb23c965f61e0e5757570333f73d"
  license "Apache-2.0"
  head "https://github.com/BoundaryML/baml.git", branch: "canary"

  livecheck do
    url :stable
    regex(/^baml-wrapper[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5b387ac7625ae860bf341d12f9fa8274f99176e1a20c2c7fc7cdf64be52ff5b5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d8fb3f5ce5ba8be92bc28b2b806f873dfeca6ee8d195fad51be95a1908bc53ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "320529c58771dc173ea287e28eb05d11b011d8a33e4ccc18a90e98620d7e1a6c"
    sha256 cellar: :any,                 arm64_linux:       "47a0108fcd3e2085e068defc44f878ba06e5f9a1a73e20bf4f2f87773773e1a3"
    sha256 cellar: :any,                 x86_64_linux:      "aea15b4fabbb38e22aa1fecc6f02cec4d9bfb318b17435772163b41a8ab174ca"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(
      path:     "baml_language/crates/baml",
      features: "no-self-update",
    )
  end

  test do
    ENV["BAML_HOME"] = testpath/"baml-home"
    ENV.delete "BAML_VERSION"

    system bin/"baml", "toolchain", "use", "canary"
    shell_output("#{bin}/baml run -e 'baml.sys.exit(42)'", 42)
    assert_match "self-update is disabled in this build",
                 shell_output("#{bin}/baml self-update 2>&1", 1)
  end
end
