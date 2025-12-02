class Aztfexport < Formula
  desc "Bring your existing Azure resources under the management of Terraform"
  homepage "https://azure.github.io/aztfexport/"
  url "https://github.com/Azure/aztfexport.git",
      tag:      "v0.18.0",
      revision: "c787766b069dc1cee0cd9d50801847d230a0d264"
  license "MPL-2.0"
  head "https://github.com/Azure/aztfexport.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f3a5ee03fca178adacba476b73a2176c24c4dddb35232c0baf49b350c52afcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4315e5a84cfa58065d8474d8be1cc9f2f520590426ef77c6a1c070c19fea526"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4315e5a84cfa58065d8474d8be1cc9f2f520590426ef77c6a1c070c19fea526"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4315e5a84cfa58065d8474d8be1cc9f2f520590426ef77c6a1c070c19fea526"
    sha256 cellar: :any_skip_relocation, sonoma:        "372087c2a171dd4d5b27e83e24a4e893ab36c7706882766de524e22cdd92cfa2"
    sha256 cellar: :any_skip_relocation, ventura:       "372087c2a171dd4d5b27e83e24a4e893ab36c7706882766de524e22cdd92cfa2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ce117fbfcb7aeaaafa8afd030e2308fed365f704e8429ad1d5340661193410b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baf8a4f42df5eeffa6ef8cbcc64d5f96623d382751377ad04072fb38ba8a8cd9"
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
