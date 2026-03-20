class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift-online/ocm-cli/archive/refs/tags/v1.0.12.tar.gz"
  sha256 "07921ab66e993bddbf8e91708069803221183da9502fcec9754c6c4b97eb8ada"
  license "Apache-2.0"
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a01162d612656c6169036f10a6b3114248f566e37e8e4b5a7cb19a2727a9f73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16c1f70d57338e5c778a0c6dbb15c1646a0742bf98e10f71f9a6623638592241"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23893cd9d5c962ea075b0cc7f88e3220c2512dd43623246949c32e29d316a5e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2dab8a77b1bf0f9a6568c8520247251b48c37cf31b2f415ca0b78f9e1f0fc6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f58e024d699a18a46813713357e6beb8a89b2c179c488a26208a3b4ed3800a9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2897447879051cad63ecba3611390765e64404736a9e9e5889834f8a8808e56"
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
