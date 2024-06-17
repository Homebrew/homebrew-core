class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https://cyclops-ui.com/"
  url "https://github.com/cyclops-ui/cyclops/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "215a7879fe12303e1e3eac9fefa9065f19cb838c7516ca06846e56395ff02bf1"
  license "Apache-2.0"
  head "https://github.com/cyclops-ui/cyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "16cef0f69afbec037ffd6f360bd152de2c9f44967b024b76a77894b0b579f81a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2047be7fb04dd75345c3840eb4a68de09fbfe86a12ae522959ab056d32150ac0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55730e9cff9a7b653e8e8b89719331e56ffdf6e84ef09b9c8029dfa11b7030bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "13eac8b83abbd374a04a419930ffcccf8c70f40945e1089f705f42011cf5343c"
    sha256 cellar: :any_skip_relocation, ventura:        "f50643ddd529ed066179f3e485a7d24a4a9d6eaaa058e5406d627973c5eb3aab"
    sha256 cellar: :any_skip_relocation, monterey:       "a4be05ad02050af3b50f978c22cd22c69b6af992b043a0630f6757c2c0eca5c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0aaa19dd1676a657037182daf98dab33bb107313c1a3fe59e6ca1019393bdb3d"
  end

  depends_on "go" => :build

  def install
    cd "cyctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/cyclops-ui/cycops-cyctl/common.CliVersion=#{version}")
    end
  end

  test do
    assert_match "cyctl version #{version}", shell_output("#{bin}/cyctl --version")

    (testpath/".kube/config").write <<~EOS
      apiVersion: v1
      clusters:
      - cluster:
          certificate-authority-data: test
          server: http://127.0.0.1:8080
        name: test
      contexts:
      - context:
          cluster: test
          user: test
        name: test
      current-context: test
      kind: Config
      preferences: {}
      users:
      - name: test
        user:
          token: test
    EOS

    assert_match "Error from server (NotFound)", shell_output("#{bin}/cyctl delete templates deployment.yaml 2>&1")
  end
end
