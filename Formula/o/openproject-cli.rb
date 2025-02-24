class OpenprojectCli < Formula
  desc "CLI for the OpenProject APIv3"
  homepage "https://community.openproject.org/projects/cli/"
  url "https://github.com/opf/openproject-cli/archive/refs/tags/0.5.3.tar.gz"
  sha256 "464801e2550a22db631a90b7f1da6b75662270b49f50b9e313d48d2c7727eef6"
  license "GPL-3.0-or-later"
  head "https://github.com/opf/openproject-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => ["1.24.0", :build]

  def install
    if build.stable?
      op_cli_version = version.to_s
      op_cli_commit  = "unavailable"
    else
      op_cli_version = Utils.safe_popen_read("git", "describe", "--tags", "--dirty").chomp
      op_cli_commit  = version.commit
    end

    ldflags = %W[
      -s -w -extldflags -static
      -X main.version=#{op_cli_version}
      -X main.commit=#{op_cli_commit}
    ].join(" ")

    with_env("CGO_ENABLED" => "0") do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end
    prefix.install_metafiles
  end

  test do
    assert_path_exists bin/"openproject-cli"
    assert_match "OpenProject CLI: #{version}", shell_output("#{bin}/openproject-cli --version")
  end
end
