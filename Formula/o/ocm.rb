class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift-online/ocm-cli/archive/refs/tags/v1.0.13.tar.gz"
  sha256 "7ac0158b6a53ff56159c18decb0b8cc43739b7421120d4d88da0c6c721a25310"
  license "Apache-2.0"
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da3bb72fb8ba7464f1cc46b04acae51703a1fe77d1ed3d64a430bf2146491fe3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "359d8fe5e47d93151bb05bed9c71ff241eea4dd396bc2637eb5b99876455f665"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80691cafee10deb46f025c35740f1e39ea50e7a2c45c9dcae38019a70cc27f9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c904d308cd0efaf6ef0b9d09364ec7eed0a3c4097f3485fa05ae417af598baee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff1a75d7df9bc7ad5ca21d2272ef4eac9c54b013fa580ca8edfada8d2340154d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a22117289214bd859fe7fec61611a6631d1382e2f538d29c1d57af93969cb1fe"
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
