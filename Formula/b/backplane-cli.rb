class BackplaneCli < Formula
  desc "CLI for interacting with the OpenShift Backplane API"
  homepage "https://github.com/openshift/backplane-cli"
  url "https://github.com/openshift/backplane-cli/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "77a05c4562418dd7f3d45edf7340a7c186a038912b80f4ffd353b2372d4e5f80"
  license "Apache-2.0"
  head "https://github.com/openshift/backplane-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10b55f22870ddcc29f2c5faa5ab3a1a095161f07c109f35633db4fb6769657ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "beb0b42838f487db75e378f591038100da87ab810141baa1c116cf68b451e057"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33de3b613414dc268fc0326e3dfadf3933638616b391733e9e2a95981d368e46"
    sha256 cellar: :any_skip_relocation, sonoma:        "2411ca384448169354c28ce8a12fb0c31617c2f47b61ff4625ee63be1f65fc6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65f5a326fab4c665b6fee40f0082f8b796b9a68005278a513658a5bfde877bcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c99f88d746acf54fd5b463ce0706645215d197dab360be74cb348d447fc8c0ee"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openshift/backplane-cli/pkg/info.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"ocm-backplane"), "./cmd/ocm-backplane"
    generate_completions_from_executable(bin/"ocm-backplane", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocm-backplane version")

    # Verify config set persists to disk
    ENV["BACKPLANE_CONFIG"] = testpath/"config.json"
    system bin/"ocm-backplane", "config", "set", "url", "https://test.example.com"
    config_json = JSON.parse(File.read(testpath/"config.json"))
    assert_equal "https://test.example.com", config_json["url"]
  end
end
