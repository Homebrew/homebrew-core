class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kwctl/archive/refs/tags/v1.28.1.tar.gz"
  sha256 "e48a34126e54f90a012334247dd2c6b5d05703a43596edc866d9e4f1c19d4046"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79aa0206eb5898890afb6aab3587237d9318e687031b7bdf7e5d32e1981abcac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8b33fe5d4b78a1a74d821bdedd936ee656b0074c971abc073b6e770d3dd8579"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a0c8c168b6d51198ee774b9cf6558172a184caf286b573ab2ad3ed3be06ed79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d87cd2e60bddd5bac2bc9952a0aae743c81e425bf4fb359053e7863f55d773a"
    sha256 cellar: :any_skip_relocation, sonoma:        "68f7c879a1cc8e4eb8dc60c8fdae1e1a76f4e6e8f1fb73dbb5491d3c1283e1e1"
    sha256 cellar: :any_skip_relocation, ventura:       "fc85542137f0cb7ecc103759cfb8b5e83abf95a147e40b59a385b77ba2a88475"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d348551d9406760e8cc9ae076134d6721749d1a91ad1820fa1ead54b3968994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bec86eae715aa814848e406c1aa30eed9126bac9b1a57af88d74b21bab8e73e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"kwctl", "completions", "--shell")
  end

  test do
    test_policy = "ghcr.io/kubewarden/policies/safe-labels:v0.1.7"
    assert_equal "kwctl #{version}", shell_output("#{bin}/kwctl --version").strip.split("\n")[0]
    system bin/"kwctl", "pull", test_policy
    assert_match test_policy, shell_output("#{bin}/kwctl policies")

    (testpath/"ingress.json").write <<~JSON
      {
        "uid": "1299d386-525b-4032-98ae-1949f69f9cfc",
        "kind": {
          "group": "networking.k8s.io",
          "kind": "Ingress",
          "version": "v1"
        },
        "resource": {
          "group": "networking.k8s.io",
          "version": "v1",
          "resource": "ingresses"
        },
        "name": "foobar",
        "operation": "CREATE",
        "userInfo": {
          "username": "kubernetes-admin",
          "groups": [
            "system:masters",
            "system:authenticated"
          ]
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
    JSON
    (testpath/"policy-settings.json").write <<~JSON
      {
        "denied_labels": [
          "owner"
        ]
      }
    JSON

    output = shell_output(
      "#{bin}/kwctl run " \
      "registry://#{test_policy} " \
      "--request-path #{testpath}/ingress.json " \
      "--settings-path #{testpath}/policy-settings.json",
    )
    assert_match "The following labels are denied: owner", output
  end
end
