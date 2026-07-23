class Chainsaw < Formula
  desc "Rapidly Search and Hunt through Windows Forensic Artefacts"
  homepage "https://github.com/WithSecureLabs/chainsaw"
  url "https://github.com/WithSecureLabs/chainsaw/archive/refs/tags/v2.16.2.tar.gz"
  sha256 "b2ef92527c76829a0220c6c995ad97111cb44d1029f09d679f2246c73a5efc00"
  license "GPL-3.0-only"
  head "https://github.com/WithSecureLabs/chainsaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85065b131882ed82b02209c220f58327b81e59daf6f763899b05f1df2d385acf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4139ff066bf414e70c4af9d8d31b6cc0b9178dde959af2246ebe03e0cfea295a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6144d2e4b19a95d58125d33c90df6936233e51d82d9b27c0ccc9caedbcb53f57"
    sha256 cellar: :any_skip_relocation, sonoma:        "9595cfea7cba2a478987da53b9ffe1920facf978aaa0cfdaef930af813e0a747"
    sha256 cellar: :any,                 arm64_linux:   "abcaabc2f04ed709dbceaaceb3b7c3137cc15045b44b5cc46924d1c6cd02ad83"
    sha256 cellar: :any,                 x86_64_linux:  "90235c75e78f759dab867317782247ef1d277d98f62891959f71835c0c326612"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    mkdir "chainsaw" do
      output = shell_output("#{bin}/chainsaw lint --kind chainsaw . 2>&1")
      assert_match "Validated 0 detection rules out of 0", output

      output = shell_output("#{bin}/chainsaw dump --json . 2>&1", 1)
      assert_match "Dumping the contents of forensic artefact", output
    end

    assert_match version.to_s, shell_output("#{bin}/chainsaw --version")
  end
end
