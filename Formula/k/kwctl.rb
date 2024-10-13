class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kwctl/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "d26b7706704901c8dde9121c1c00a9174e5a5bd081055e304210387bfb85c616"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2084798a4e57f7288dfaa47a24bfe66dae8cf395af2e6dd83bc2cc9a171e81d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bcddf06e296bed215a05972e6cd0f613d2ac412520e57a49b39e82bfce097bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3cc50c4db5ce89c8131ea7af4e5bb4b33f583e7e68beb345ce808659f6db95d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8a0769ad648d0d0abb56cc9ba8f4be42bea3f862c6c321b1f7ac4a0024db299"
    sha256 cellar: :any_skip_relocation, ventura:       "f71c1dd00bede9f4b884e22294d2d1743cd74d6890ca0ba1d3bf190128d09ba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09cc2929d4ae648edd328aaf151cabe47b660e03df87268182d49165840aba30"
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
