class Baml < Formula
  desc "Programming language for agents"
  homepage "https://boundaryml.com/"
  url "https://github.com/BoundaryML/baml/archive/refs/tags/baml-wrapper-0.2.4.tar.gz"
  sha256 "9096895f1f48ef2f483766ad1b9915a1b0ba79b5f9e9d45ab46804bd46765add"
  license "Apache-2.0"
  head "https://github.com/BoundaryML/baml.git", branch: "canary"

  livecheck do
    url :stable
    regex(/^baml-wrapper[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87be1d224aba4748fb428893ece4e8ae0dbf8d2b1bba0404e9cc03fca6e10c8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3057eedcb6ca988ea768874c51346a5bf1f9dabafd1283d79da2c11684b3f439"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46f19c3090d81788c3fd70570bb01407f354d20d3caed0e9a602c5541d4a4296"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1f7ef1ce701be747a4d31bb938170f828a03f83196eb94c56a0f9da902092f2"
    sha256 cellar: :any,                 arm64_linux:   "63096151f86f8e21b9bab9c12ff0a19ad195ca18a0a41e669a648618991b48e1"
    sha256 cellar: :any,                 x86_64_linux:  "79e380dec9474ebc46fe809b95a6494dd9822c3f23dbeb4ca9d459abd126ec15"
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
