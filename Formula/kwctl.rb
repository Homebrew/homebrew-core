class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kwctl/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "b86be1945bee410d23a584e5450f036f9da5e8528df72b98d9a0fa5a978eaf69"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f73e6fc2adb31a472d466b12da75d3c2881148a5e82ef6f46df0784e8744590"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5822a144eb36da54e3df4b58b06f71f7637a299a9c9a3dfa3348831b545eb020"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b81deae6ccc60d9a9ccc31e1b5d42f14693e2cfd97da1b4ba9368d4f57e2ca6"
    sha256 cellar: :any_skip_relocation, ventura:        "23ce6aeab2f432514779bd03a341752bfe086ab067ab82213afac43faa59b33b"
    sha256 cellar: :any_skip_relocation, monterey:       "faf14344f8b44f6c8054eda21261fd921e1f693ab651905a3434d09c081bbd10"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9cbd50f0483b6b26b0553d41bfa1147fc5bfa89349918864330c00d7c5edbb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97234dca75be55a936e95ca0d88c3789171d7ca3e87655d71d2ffb05ddb99475"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_policy = "ghcr.io/kubewarden/policies/safe-labels:v0.1.7"
    assert_equal "kwctl #{version}", shell_output("#{bin}/kwctl --version").strip.split("\n")[0]
    system "#{bin}/kwctl", "pull", test_policy
    assert_match test_policy, shell_output("#{bin}/kwctl policies")

    (testpath/"ingress.json").write <<~EOS
      {
        "uid": "1299d386-525b-4032-98ae-1949f69f9cfc",
        "kind": {
          "group": "networking.k8s.io",
          "kind": "Ingress",
          "version": "v1"
        },
        "object": {
          "apiVersion": "networking.k8s.io/v1",
          "kind": "Ingress",
          "metadata": {
            "name": "tls-example-ingress",
            "labels": {
              "owner": "team"
            }
          },
          "spec": {
          }
        }
      }
    EOS
    (testpath/"policy-settings.json").write <<~EOS
      {
        "denied_labels": [
          "owner"
        ]
      }
    EOS

    output = shell_output(
      "#{bin}/kwctl run " \
      "registry://#{test_policy} " \
      "--request-path #{testpath}/ingress.json " \
      "--settings-path #{testpath}/policy-settings.json",
    )
    assert_match "The following labels are denied: owner", output
  end
end
