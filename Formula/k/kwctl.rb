class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kwctl/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "de4dd48a3765a7f186412d2a054c045714d663480a411402fcf4dd16543a2224"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8403bd9a9455cc509e8f19883d625367aa19970fccba4356f5840721ca1068f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "055e87c984e6827749ba52ea53ad71b1709a337a3af2f2a3e9c29094de81d057"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "042de8495032a5c492e95e1c499bcf401af52dfbda407a68f03e31af8bcf132c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6dbf407d0f210ca4a4fc68039929cf7ddd5f0d6826cf8bab90b42df52400e135"
    sha256 cellar: :any_skip_relocation, ventura:       "308e110f7e5bedb8714700ed872f2f0586b7f0f87e70ec341ada3e120f50bc95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cddc4db844b34e2d29b703c157bbd3dd8eed7316fe6d1afcc6176a2ae0b70c41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dac45ac1acd07349f5494b5bd26c0953958571547301ce8f345587f7360c306f"
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
