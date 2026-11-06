class Baml < Formula
  desc "Programming language for agents"
  homepage "https://boundaryml.com/"
  url "https://github.com/BoundaryML/baml/archive/refs/tags/baml-wrapper-0.3.1.tar.gz"
  sha256 "9948cd57ed830b200a955119b31fe48753464e7e0d2050105056705d425f74ab"
  license "Apache-2.0"
  head "https://github.com/BoundaryML/baml.git", branch: "canary"

  livecheck do
    url :stable
    regex(/^baml-wrapper[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7850121d510b561832f56b89458467198c5b9e75dbd89959374de5f9791f33c3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9e792269e84d9fdd1dc819992bb8f854a888975cc0346dcab9264800762cbd80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "56a650c20e893f8d89d9ded4d884659cc4d91df1583d6e591bdc1219949fb199"
    sha256 cellar: :any,                 arm64_linux:       "a4a0ce2d2efd3219c0a5c9988a88b46fa985b18300776caac360b4ba99db9027"
    sha256 cellar: :any,                 x86_64_linux:      "fee89ed477a062def6668cd7c0ca6a415855aa24d8ef0abad2004f3cc6a94d19"
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
