class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.10.1",
      revision: "c48360f51c53d2029ab6721ad4d012f9e14df846"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    manifest_sha256 "008038faed5ab6aba3d9e139e45ef25661fef204b2c92ade41acc8e703612a19"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ea9b8f1d58e571f8107c687386dc86c9c2dd8248cc8285452e4419d7d4b9e6e8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0596022ecfbad4b2551ff32e81b2bc9c74f1711dbeb4d538e1589e3ff7b296db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "693029c407a07cb708b1f886cdb058e8b322b27ba789c4e08aad25f373fa57f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3ee02e9402600ab7688a098f45aad7259d4d75928d1a51a4701a01056034b45a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0ea1496cbb669f634817c728e8bdad8706e7801c5f8887f433b23fec7af8dfac"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  deny_network_access!

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    # TODO: Drop GOPATH when merged/released: https://github.com/docker/cli/pull/4116
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/docker").install_symlink buildpath => "cli"

    ldflags = [
      "-X", "github.com/docker/cli/cli/version.BuildTime=#{time.iso8601}",
      "-X", "github.com/docker/cli/cli/version.GitCommit=#{Utils.git_short_head}",
      "-X", "github.com/docker/cli/cli/version.Version=#{version}",
      "-X", "\"github.com/docker/cli/cli/version.PlatformName=Docker Engine - Community\""
    ]

    system "go", "build", *std_go_args(ldflags:), "github.com/docker/cli/cmd/docker"

    Pathname.glob("man/*.[1-8].md") do |md|
      section = md.to_s[/\.(\d+)\.md\Z/, 1]
      (man/"man#{section}").mkpath
      system "go-md2man", "-in=#{md}", "-out=#{man}/man#{section}/#{md.stem}"
    end

    generate_completions_from_executable(bin/"docker", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  def caveats
    on_linux do
      <<~EOS
        The daemon component is provided in a separate formula:
          brew install docker-engine
      EOS
    end
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}/docker --version")

    expected = "Client: Docker Engine - Community\n Version:    #{version}\n Context:    default\n Debug Mode: false\n\nServer:"
    assert_match expected, shell_output("#{bin}/docker info", 1)
  end
end
