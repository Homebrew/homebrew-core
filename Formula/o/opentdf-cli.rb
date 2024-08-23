class OpentdfCli < Formula
  desc "OpenTDF command-line interface"
  homepage "https://docs.opentdf.io/"
  url "https://github.com/opentdf/otdfctl.git",
      tag:      "v0.11.4",
      revision: "1e64065d08547658e436dc167b108c2a6e9c0ccd"
  license "BSD-3-Clause-Clear"
  head "https://github.com/opentdf/otdfctl.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  keg_only :versioned_formula

  # disable! date: "2025-01-01", because: :deprecated_upstream

  depends_on "bash" => :build
  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  on_macos do
    depends_on "coreutils" => :build
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/opentdf/otdfctl/pkg/config.Version=#{version}
      -X github.com/opentdf/otdfctl/pkg/config.BuildTime=#{time.iso8601}
      -X github.com/opentdf/otdfctl/pkg/config.CommitSha=#{Utils.git_head}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags:), "-o", bin/"otdfctl"

    generate_completions_from_executable(bin/"otdfctl", "completion", base_name: "otdfctl")

    # TODO: install man docs
    # Leave this step for the end as this dirties the git tree
    # system "hack/update-generated-docs.sh"
    # man1
  end

  test do
    run_output = shell_output("#{bin}/otdfctl | sed -r \"s/\x1B[[0-9;]*[mK]//g\" 2>&1")
    assert_match "otdfctl - OpenTDF Control Tool", run_output

    version_output = shell_output("#{bin}/otdfctl --version 2>&1")
    assert_match version.to_s, version_output
  end
end
