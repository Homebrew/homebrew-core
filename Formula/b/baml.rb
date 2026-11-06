class Baml < Formula
  desc "Programming language for agents"
  homepage "https://boundaryml.com/"
  url "https://github.com/BoundaryML/baml/archive/refs/tags/baml-wrapper-0.3.0.tar.gz"
  sha256 "e5bc34eb29f88a5089f3a7e1c811f95fcf12d0254a952810e04cf252b29b40ab"
  license "Apache-2.0"
  head "https://github.com/BoundaryML/baml.git", branch: "canary"

  livecheck do
    url :stable
    regex(/^baml-wrapper[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d82836feb4ca1ee54706c10c4c66d9183efba4062388b24f0475c840f2de1327"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "394163ae77ce47b05fd4d9c29754d4d1609e6dc1079493708b0255eac4057fe5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4fc2bb7c646e6cf0962a190d512cfccc7222b5ac6977ef05cc79a784c5c942aa"
    sha256 cellar: :any,                 arm64_linux:       "961ed1568f6fd8856960d8523024d6e9139a82e08d9e144c1a7446bfe872112a"
    sha256 cellar: :any,                 x86_64_linux:      "744e02a811bd6ff606c063b10a576ce9b74775778a29e8fd58ef4cc60bda1173"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    cd "baml_language/crates" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    system "cargo", "install", *std_cargo_args(
      path:     "baml_language/crates/baml",
      features: "no-self-update",
    )
  end

  test do
    ENV["BAML_HOME"] = testpath/"baml-home"
    ENV.delete "BAML_VERSION"

    system bin/"baml", "toolchain", "use", "--global", "canary"
    shell_output("#{bin}/baml run -e 'baml.sys.exit(42)'", 42)
    assert_match "self-update is disabled in this build",
                 shell_output("#{bin}/baml self-update 2>&1", 1)
  end
end
