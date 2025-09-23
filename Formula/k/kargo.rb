class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://github.com/akuity/kargo/archive/refs/tags/v1.7.5.tar.gz"
  sha256 "5f7c61032ee59f48fe2013df780c7cb1e5e80ba70c1c496402939ee573536660"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70416bbadff626f1820c46c089228424ec732b8202daa4a498ed807bf0290a4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b5c969480127363102cf05414691b6f445aee3e60b72918dfbc0657ba72260d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "579c4fb4b28f3f7f5dbd60e9a5d30937712efd1f762b1fbb8fd254452fb79df7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e29be057f05fca37e93af3c08dda24c7c083b695474352a8f3882510ec69b4fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "233d57370efce1b75fe2683fcb398959e6cd7bb0a3e6ab26167d6e2c8ae03095"
    sha256 cellar: :any_skip_relocation, ventura:       "1f6c3dd39696c5159e5449154f3cd4a733950382db36f718651d07d5345f4eb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c83edbfc1cb07c06de1eebeda0a51289364648673ac41e020ede7818237fe7b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8a3afa6de215053eb6338a1673096cb9648614a1bdf5dc6670513d988b7226b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end
