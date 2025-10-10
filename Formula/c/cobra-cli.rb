class CobraCli < Formula
  desc "Tool to generate cobra applications and commands"
  homepage "https://cobra.dev"
  url "https://github.com/spf13/cobra-cli/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "9c9729828a035eff012330d5e720eec28d2cb6a1dbaa048e485285977da77d15"
  license "Apache-2.0"
  head "https://github.com/spf13/cobra-cli.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2388295cd0c715263114639062592b03f4366be723c206fdb1bd65a74dc3f09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d05baad8dd6bcebac5c184b14d30a29ac84e15c8f5cb74a19f604c87d4a42869"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d05baad8dd6bcebac5c184b14d30a29ac84e15c8f5cb74a19f604c87d4a42869"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d05baad8dd6bcebac5c184b14d30a29ac84e15c8f5cb74a19f604c87d4a42869"
    sha256 cellar: :any_skip_relocation, sonoma:        "66330dc06dd3a086ca90c0c5fa45e3b69295fbe30a029a70f4f7dc70c7b6daef"
    sha256 cellar: :any_skip_relocation, ventura:       "66330dc06dd3a086ca90c0c5fa45e3b69295fbe30a029a70f4f7dc70c7b6daef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9958c8c2360e475734d0f1c3fd89d040887059714787b5458b306121d73b67c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "116ebe675a0b8b1f1c398867a95cf3fa0c27b097e64ae5772e836c83113f4ddb"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"cobra-cli", "completion")
  end

  test do
    system "go", "mod", "init", "brew.sh/test"
    assert_match "Your Cobra application is ready", shell_output("#{bin}/cobra-cli init")
  end
end
