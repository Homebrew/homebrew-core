class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://github.com/j178/prek/archive/refs/tags/v0.2.28.tar.gz"
  sha256 "402406fa5bcd1c4b80fa20316b6e63420dc4616d00fb7aac1d743262050740d1"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d306265da54e12f4ad72ff30b54b825c495a9414662f72428970b3c853731e50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c99fff79c8f45c56038b8bbcd49fc1deb5b02abab6bd8a5eadff06de7a05454e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb240079e96cabcb0f8fa8d002b6f11ee267bd1f72774378562a54fce87a3e43"
    sha256 cellar: :any_skip_relocation, sonoma:        "150b636bee3ea80398f6304ffe83ea09ab4ac3fc39d193996518119f6260c1ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18212800ba061e6e42ba8bf4b410c025e0b05a3f3c4c608070369c0f80d85a5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bce016902eee745a06378d9a38b8fb2f9343e0266141c3ee06f5c54dc8f416f"
  end

  depends_on "rust" => :build

  def install
    ENV["PREK_COMMIT_HASH"] = ENV["PREK_COMMIT_SHORT_HASH"] = tap.user
    ENV["PREK_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "crates/prek")
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end
