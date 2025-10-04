class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kwctl/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "577d62925ec617720d4a21ee5a57833561e2bbed4c085e185e0dc8be7ecda341"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88040dfe67e1efd976fa5d297098876f38bfaa8d25d1734b1ac5c63fc0b1329d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8fcafdec026a0ee28c0a3bc5194162e858100f65cd380746443637d3f25d61b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "181cb86b6f54b590b4190b20cc042e2700a8cfb95cbe8adbc1c93669314f2c41"
    sha256 cellar: :any_skip_relocation, sonoma:        "002af58580976a7a3e8de502d08c892daaa6af16c15ac6bde0c5ffa22cd46e19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95ff752e867f043ef16f467d44ed217cdfaf7eab550950ed48bdf4d4e493899e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f16141073ca1bf40964602e8c38ba9d1cc85e500da6d775972686f34de51a57"
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
