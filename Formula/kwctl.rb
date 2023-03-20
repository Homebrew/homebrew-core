class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kwctl/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "a09eef843cfc8301706718165dac499fac546b5cc7dc170f7b2dfa2ab0f25c07"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2011149b19a67cc3f1ea8eb539464a052fdb5ef689ed3eea110e53053f0f19a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "503425d99e773c7fe953c2c4a5e062a31f51ddfed412223c2dd49463ca32bab1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b9223f94cfc784e7fd4abd71cc1ba75a44ced7ac5fedaad1b6674c8b68ba049"
    sha256 cellar: :any_skip_relocation, ventura:        "c47e3ff8eb049a6d2549cc4f722949b29044e5ec3a81ef999f81570b34be2124"
    sha256 cellar: :any_skip_relocation, monterey:       "53bab7336e137d7f1d6c2f4071d6987108ae343ad965dc464d1739afc859d17c"
    sha256 cellar: :any_skip_relocation, big_sur:        "72239fc5132f2a49a46cc1a1e13a0d1c6d413491e71270e0b31bfabe996918e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05f38a10b116c057ac821d784f450fc692162a4fbc7d6010f476563927ccea84"
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
