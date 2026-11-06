class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.9.3",
      revision: "5457199aa57c45e990c59c89cab5f02b817238d7"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "39d0113e0e433d22fb070f13f25ad95f7a7c360918f12ca14d02ec680cebce74"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "42aa841a6f84f15241b68eaca7cebdaea5108a8f003cfb176acbd8aa0d7d4f67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8ba3474edb56a48871ecb951263d48687cf1e9114f8889a4f8efc2df94a0f949"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5351573fad54f636a8af77db5340cd0d75b919bcb4fe8188c56b53dabc193e3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "745c4431fe2c2da525e91ca7f95febde82a2698fd13d3551ca99264c0d757443"
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
