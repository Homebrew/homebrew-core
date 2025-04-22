class Aztfexport < Formula
  desc "Bring your existing Azure resources under the management of Terraform"
  homepage "https://azure.github.io/aztfexport/"
  url "https://github.com/Azure/aztfexport.git",
      tag:      "v0.17.1",
      revision: "aa75416cc3159a277f2e54cc2044ddea7122bc98"
  license "MPL-2.0"
  head "https://github.com/Azure/aztfexport.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "494fd1d33cf38dae763505225a477cfe42730434250c67aeb314d1c5283948c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "494fd1d33cf38dae763505225a477cfe42730434250c67aeb314d1c5283948c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "494fd1d33cf38dae763505225a477cfe42730434250c67aeb314d1c5283948c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff3e1fb1e23a62f75599e01e3a5330d3a5aedd11993183b27f3c5e47def155d0"
    sha256 cellar: :any_skip_relocation, ventura:       "ff3e1fb1e23a62f75599e01e3a5330d3a5aedd11993183b27f3c5e47def155d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acdd35577a41cf46edf936c43c431e984ded8c05860f1af490afcc4d2bdd191c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b3c53c15e3bb6b3ad58789f9d95c18f3b7f04201e963a23272655fabec4bdfb"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'main.version=v#{version}' -X 'main.revision=#{Utils.git_short_head(length: 7)}'")
  end

  test do
    version_output = shell_output("#{bin}/aztfexport -v")
    assert_match version.to_s, version_output

    mkdir "test" do
      no_resource_group_specified_output = shell_output("#{bin}/aztfexport rg 2>&1", 1)
      assert_match("Error: retrieving subscription id from CLI", no_resource_group_specified_output)
    end
  end
end
