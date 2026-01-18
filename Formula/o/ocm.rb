class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift-online/ocm-cli/archive/refs/tags/v1.0.10.tar.gz"
  sha256 "e8dd8a436892f0b75d703f98e4dabe66c6e3e567a6afb4511ef252045ff1229b"
  license "Apache-2.0"
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acb09532281c5ffb1d13a3e9a94f23481cb43cdeb754fa2d3d6afc9620d83a0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1976bdaab69a88b9dd3b5563686059a64a0b8b17e42c31517009350db8212947"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9af041a29f83799ed9e114892821cc14ae534c7f0ec1bfb63a5866d703bbc7f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "35714691631753c66cfac421425962d10db603992b69b64efcd391bf0dd418c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "458a45e2bb182a794c6f09851f74148bc25ef94280922e4ddce1b7fdc0a67f69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dbc1304ce4db4e5ab2081f89b6938be563092347773e55ad9a61fab661818ab"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ocm"
    generate_completions_from_executable(bin/"ocm", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocm version")

    # Test that the config can be created and configuration set in it
    ENV["OCM_CONFIG"] = testpath/"ocm.json"
    system bin/"ocm", "config", "set", "pager", "less"
    config_json = JSON.parse(File.read(ENV["OCM_CONFIG"]))
    assert_equal "less", config_json["pager"]
  end
end
