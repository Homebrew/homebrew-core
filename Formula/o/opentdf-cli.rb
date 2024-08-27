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

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/opentdf/otdfctl/pkg/config.Version=#{version}
      -X github.com/opentdf/otdfctl/pkg/config.BuildTime=#{time.iso8601}
      -X github.com/opentdf/otdfctl/pkg/config.CommitSha=#{Utils.git_head}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags:), "-o", bin/"opentdf-cli"

    generate_completions_from_executable(
      bin/"opentdf-cli",
      "completion",
      base_name: "opentdf-cli",
    )
  end

  test do
    run_output = shell_output("#{bin}/opentdf-cli | sed -r \"s/\x1B[[0-9;]*[mK]//g\" 2>&1")
    assert_match "otdfctl - OpenTDF Control Tool", run_output

    version_output = shell_output("#{bin}/opentdf-cli --version 2>&1")
    assert_match version.to_s, version_output
    profile_output = shell_output(
      "#{bin}/opentdf-cli policy attributes list " \
      "--host http://localhost:8080 " \
      "--with-client-creds '{}' 2>&1",
    )
    assert_match "Profile missing credentials", profile_output
  end
end
