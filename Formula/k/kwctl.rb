class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kwctl/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "2f5f96a4fea96d42826ad29a4246c595024d25b7745996b0125e9ac7587f70c9"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2cfec747a1871dc637e53ca4cf89b919733fc5c552b3b108351e55a65c2a503f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc2d52a9c049fb74da63617ce3712c362a3a6c49a97d52d1a48bfb20b58b261f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38a9bf9b21d06ef4ae0adbc028990927472c6efe28b6d5cf293e442655bfeb70"
    sha256 cellar: :any_skip_relocation, sonoma:         "f522d66a7d4e8952931475968533a5c124e264557ac3973c74ac96bbfaed79cd"
    sha256 cellar: :any_skip_relocation, ventura:        "c26afff84109b9303e6947e22e561259d88aa926305383fd5357e60bdcc3c96a"
    sha256 cellar: :any_skip_relocation, monterey:       "91e198473100802a69bdc1800d6cdc6bff3d4874ad2b34c3aaeef7be98f79df4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6af1d64442412b93b20b290a4b7d2c61f186158aa343ec45dd99ca7dac9426b9"
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
