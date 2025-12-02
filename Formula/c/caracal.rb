class Caracal < Formula
  desc "Static analyzer for Starknet smart contracts"
  homepage "https://github.com/crytic/caracal"
  url "https://github.com/crytic/caracal/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "70a505b46d19cc389fa11bc17bed106e15ede6b076fb1f8b350a4ccabb4e7052"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/caracal.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "736248b14af4194e38b8d5d8103f2f649cc1293391d0ca147f1ead5529e2d3d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b8b9b99080c463030eb02044b0db946992bba13ef79f693498b6f154a41d5407"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ad1176b86b6cac2c478e4728cb7212521b8875c5454f3f5775287759d4f3edd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c586d3c8ef371164a618263e0227375fb6f235a8eb0a1565613dd5f1d01228e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d78f933e2351cb5e1d96665d594d638db68fe7237b286570de2f4d666a0f445"
    sha256 cellar: :any_skip_relocation, sonoma:         "0436cb1382e79a270c8b2bfbe77cc0943c712cb42e1103ad8d80f758574e7421"
    sha256 cellar: :any_skip_relocation, ventura:        "b853f1410774434cbeb8d6ee8c167c116f7579fb4d568f358644499b90dfeb18"
    sha256 cellar: :any_skip_relocation, monterey:       "d618e73c6a168a00114eba5d298212c0ba54b443cde9747eb9913e7236c23701"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fcf41d78db1a48f3bf7ac67137292caa0ebaa23f153fe85c1e4b899b5b7cafa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2409f8e727bd6d09a351013a764c7584f7bb4efafe549d4c5df7572f7d839d1f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # sample test contracts
    pkgshare.install "tests/detectors"
  end

  test do
    resource "corelib" do
      url "https://github.com/starkware-libs/cairo/archive/refs/tags/v2.5.0.tar.gz"
      sha256 "0c21b58bc7ae2e8a6d47acedc4d20f30a41957deb6e24f8adaf31183112f8a4d"
    end

    resource("corelib").stage do
      assert_match("controlled-library-call Impact: High Confidence: Medium",
                   shell_output("#{bin}/caracal detect #{pkgshare}/detectors/controlled_library_call.cairo " \
                                "--corelib corelib/src/"))
    end
  end
end
