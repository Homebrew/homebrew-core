class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift-online/ocm-cli/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "517bf06ca0185fa6e6debece168a83ec63a28cda71477f90a7889921b7cc703f"
  license "Apache-2.0"
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dec937d8c52fdbd9cec924899c1e88d76912f2ef8e9b4893ad63ce7c1745908"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2702120f14af14d391a5d1d4bec7c7b56366526dd50e4535c4e506344b22235"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b66aa2e4cedc890b370c40d4ec5a75b6ef5af5b6e8ba9ddc8fbfd58320aa589"
    sha256 cellar: :any_skip_relocation, sonoma:        "297b69f6612e5adf0c02b2707b53a0c3d2e66301599267fe555921ab58207d2b"
    sha256 cellar: :any_skip_relocation, ventura:       "ebb746a466988fd7dbc251b2753fc65e3f9b41dae7311afa2c8ed269921a884c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5d8793d32d0e2ca7e7f2b79ac9daa9f1ffdea4b92cfee811ae796e84416fd82"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ocm"
    generate_completions_from_executable(bin/"ocm", "completion")
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
