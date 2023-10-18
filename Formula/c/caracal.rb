class Caracal < Formula
  desc "Static analyzer for Starknet smart contracts"
  homepage "https://github.com/crytic/caracal"
  url "https://github.com/crytic/caracal/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "dcc8f8ebbede56c9f68e025f444ede4f5966dc6c1c2695f09f999cf8f26f26af"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/caracal.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "482e4c1e69d93c493507e9fbe032bff7aeca02921d40b0c373e2585be19a4d0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92a5ff19dd0d6fd14b436879ecac677c3f30c151d68174e25591bce5d2bfa083"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32a3b3b4e413ed14934b66cb0f0b478944cdb9a2f3f204400b6295935c529546"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f6f19d743a65d0693132ef5e981d4bad9f9d7f8a89d52cc5d0eb27d40b8221d"
    sha256 cellar: :any_skip_relocation, ventura:        "f763de6fcf0c5a065374339a2e768284717da802ec406a9f3130976872ebabab"
    sha256 cellar: :any_skip_relocation, monterey:       "bdea46ab0aa7517e1e331ebc7195d88338750b34ecdf64bd702312cd6faf258a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11ae53402991870c0172b448e6a0babb91705b2282278402a1e0e3e889c99c79"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # sample test contracts
    pkgshare.install "tests/detectors"
  end

  test do
    resource "corelib" do
      url "https://github.com/starkware-libs/cairo/archive/refs/tags/v2.2.0.tar.gz"
      sha256 "147204fd038332f0a731c99788930eb3a8e042142965b0aa9543e93d532e08df"
    end

    resource("corelib").stage do
      assert_match("controlled-library-call Impact: High Confidence: Medium",
                   shell_output("#{bin}/caracal detect #{pkgshare}/detectors/controlled_library_call.cairo " \
                                "--corelib corelib/src/"))
    end
  end
end
