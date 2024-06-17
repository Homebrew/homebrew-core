class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift-online/ocm-cli/archive/refs/tags/v0.1.73.tar.gz"
  sha256 "9116d799cd0a32775ff3b2b5b05c94839b8be4bb28fe90bb53e7a642c334104c"
  license "Apache-2.0"
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "120458702b51c080b31581f12afabf0df370c6eb9dc833ec35d7b0dd8966bb1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfc13f72b1893dfedcf3137673b22c675b0023ce6943a1f8c89493a73b4050e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c11715fe945195bd77bdb5fcba7d456d6b961ef0244095d5be86ff4b61b5c91"
    sha256 cellar: :any_skip_relocation, sonoma:         "eebd34ed2fb2c3c735f22b0cc571831b93137509b8f554c59a5f426c3b8307eb"
    sha256 cellar: :any_skip_relocation, ventura:        "6045a26a3dd54ad2c8bdc31195c2e3910da7719d43a95bf9040cb8b12b5d6515"
    sha256 cellar: :any_skip_relocation, monterey:       "746f07d4731c942fd4f4800f600ff2efb9a8b6e3ff0a7bb518768c8a658aa45f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81a0d870098771b0c1d387dff73d72b184efabceba961331e2e7b96dfae9d7a7"
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
