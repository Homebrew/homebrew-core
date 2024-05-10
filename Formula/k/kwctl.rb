class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kwctl/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "0b2f4e821c604ba0501c5805c14d613609fdb7cb9089bd8d0dfd6ad186a8d96f"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b539eb74b893f414aee2ce948130d40c5490c4abb501fe9f5e11d665ba4a2cb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0dc829ea2ce3ac6bd98ca2de81be012aee3936f3be65555c166979b610291e78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1ea2c53050c7ec386933415259cebc9f70b812e3d7f01049e3e8be339de9cbf"
    sha256 cellar: :any_skip_relocation, sonoma:         "535d0cd31ba18bc483bbc44413f6d813235832a25b0fc5b32d91730ccd89ca9f"
    sha256 cellar: :any_skip_relocation, ventura:        "cbbd0755ba18a98302945de9d7894fe4fd3f55f2dfb219f1c9ecb19ccf0c013d"
    sha256 cellar: :any_skip_relocation, monterey:       "fde55bfab428a1881e8bdda0c786ab5f08c2452c1b1edac3172044e57c7a0d66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d66443c7c97616914a139478efaba0dc84473876eaefa2410be73651e677e2b4"
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
