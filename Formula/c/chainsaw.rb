class Chainsaw < Formula
  desc "Rapidly Search and Hunt through Windows Forensic Artefacts"
  homepage "https://github.com/WithSecureLabs/chainsaw"
  url "https://github.com/WithSecureLabs/chainsaw/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "8621299c16be2545d5506448fd9748bc0524424ae46a6ddb3078dc33579e7f90"
  license "GPL-3.0-only"
  head "https://github.com/WithSecureLabs/chainsaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f34206032a5e317bfd1a87fd126e3ecdffada44ea2d3a32629e45d411aec756"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea55b34e5c67c6a54aa1857cdff9f5927ef61a8098ffca8200321855eaa01a4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e95d00c963763e3bbb6012e6ff40a186f7a50f89d714d0afd706f3829e10e77f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f9268170a071e4d0202c10b0825bdcf4db3bc353ca7134795944197753062f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "679ef4103a45e0046f6feca4b3d292cecebedf3972d33fb766687899db19c543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d204d0e9059777bbf7318481d24a5b85b1391c58b0b9eec84bee0b697280787"
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
