class Evtx < Formula
  desc "Windows XML Event Log parser"
  homepage "https://github.com/omerbenamram/evtx"
  url "https://github.com/omerbenamram/evtx/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "2fe4b453693fb13def79350fcf1ef23801e82c05e0329d0cba5ababb2c9cfae5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/omerbenamram/evtx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c545bc95bd9f334c266c9104055a638af2854d6e7e762e4b1a7a828535842f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c90eb646e4ca5d19a0a6d0e0f04229ca4d82cc2e1355e7b7a3933ae491963881"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05da606b390a3a16a27c25a5466bed23f16f3f985450f804a7ab7e79a7a3b793"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a2e32921b376260d23358571763f6673d425313a10369ae2882ea299acb49ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e435d7ae560f667f0b5db60974e017ace7aa728bc84902208450c3152ac8546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a8e490918011c0d143ebabe6a6945a75251f36b3a27a86b304eb8c1425d0ab4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "samples"
  end

  test do
    cp pkgshare/"samples/issue_201.evtx", testpath
    assert_match "Remote-ManagementShell-Unknown",
      shell_output("#{bin}/evtx_dump #{pkgshare}/samples/issue_201.evtx")

    assert_match "EVTX Parser #{version}", shell_output("#{bin}/evtx_dump --version")
  end
end
