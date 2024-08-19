class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kwctl/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "468a3c72ab82587d1fe71556e1a6b287c695ac6479af629bb9e18f467b882fd6"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90e5820f0344e75fa234967ad5f8bc4c1f274cddc37c8d81d232ba4119dbe6aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20bb8b306968afa3c8f11710e4c6e3c5cf4812c3680ab227869f7062507bc63c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77422bee6abb6b412eef45edb2a72cb02bc66423bb0450a247b8db2a4fae3a3c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f53427203efbbd59baee645f6100f8bd6206d8770f10204a600411f07738bcb1"
    sha256 cellar: :any_skip_relocation, ventura:        "c72df3a7a190e97508142c9c270a75209855c39a4d97c7cf23b2bef816904684"
    sha256 cellar: :any_skip_relocation, monterey:       "9490dc19b3fa413783343ea6c0717e1695a8475e3e41e228f331c36f6da765b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c225eb8e30b168e05135c03bcbefa8ee55608145317ab694323451cba5d6c66"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"kwctl", "completions", "--shell")
  end

  test do
    test_policy = "ghcr.io/kubewarden/policies/safe-labels:v0.1.7"
    assert_equal "kwctl #{version}", shell_output("#{bin}/kwctl --version").strip.split("\n")[0]
    system bin/"kwctl", "pull", test_policy
    assert_match test_policy, shell_output("#{bin}/kwctl policies")

    (testpath/"ingress.json").write <<~EOS
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
