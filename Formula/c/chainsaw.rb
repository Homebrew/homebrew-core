class Chainsaw < Formula
  desc "Rapidly Search and Hunt through Windows Forensic Artefacts"
  homepage "https://github.com/WithSecureLabs/chainsaw"
  url "https://github.com/WithSecureLabs/chainsaw/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "a18d42eac91dcc7ec3db511c2dc4fee31ef746616d6c933f8d7c4093ba46b629"
  license "GPL-3.0-only"
  head "https://github.com/WithSecureLabs/chainsaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d988497d54186a39c84f63124f30136441bcd183f91ab535a7a283d2e911d36"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc547c54c8782f9fa447f9c3d4f4cc3b20beb1bef2bf974990f025a6853fcb75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22811e8e2147a800ca3a656cfcab800ff1ec9d2b09a37537ecb4ae82836eaa95"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9e1a660acb348eaf71d34aa1add2f616bfbefa541e00bfd30712738e30f6628"
    sha256 cellar: :any_skip_relocation, ventura:        "918f34a63438be561650d4172b0d0ab774d30089fd9f364ecab5b0fbf4aabc24"
    sha256 cellar: :any_skip_relocation, monterey:       "07b9eb4fba9e62a32721a597a0d25183692e75c0f82a1703dc1a9a70e7f9a126"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8469c2a916a270004094e5951f9954ac589c6ee0f6149825895ae9a7b80da3b2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    mkdir "chainsaw" do
      output = shell_output("#{bin}/chainsaw lint --kind chainsaw . 2>&1")
      assert_match "Validated 0 detection rules out of 0", output

      output = shell_output("#{bin}/chainsaw dump --json . 2>&1")
      assert_match "Dumping the contents of forensic artefact", output
    end

    assert_match version.to_s, shell_output("#{bin}/chainsaw --version")
  end
end
