class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift-online/ocm-cli/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "70bb43a253768dd938619888a66b5e451f697c6d20c1094aa7f10d5d7946c34a"
  license "Apache-2.0"
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7171ca30158301e7e050d21285bc2e5c96c9fdde9ea576b3d31e14c5a9101de2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6e5a4a65165cada823829ff4bdffe7fd0616d021f2442422d85388fb3e54245"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c5a4cb916a89e0040bc0dd5797b6705f09ce2e35c33fcb9f44e724b4d97595f"
    sha256 cellar: :any_skip_relocation, sonoma:        "acc0b1d01a340f373a96cf0320d5dbef10b52b73703bc4b57372a22d312711b8"
    sha256 cellar: :any_skip_relocation, ventura:       "859ab577fc38f2aeb743688b670bb3e5a4ec729e3b6c2d230a393ac3165f0051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e55e2189836fec6ee17ffd6ef2d930619c0e2af151787c98f01b28f3b467b4bf"
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
