class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kwctl/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "b820e0b7b33d6475d7de77f2e0b4fc542e04e7b333d707fdec969ac5c6bda331"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "009aab04aad839c76aa2fcec21087a50050ad9c36a7f8bd5852b3c5937bd46c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7dd2f0e268783fe1f7248872f76573164f7fa164bd169aa8fa7582825a3e971"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a690cfdbdd6056eaf4e0940b6f8f24aa19e8e030f2689e69aa5104d4a107e332"
    sha256 cellar: :any_skip_relocation, ventura:        "4fbc4c10ee480c057c330f043c28c1990ee13d5dfcef9e196a714579ce1ebd81"
    sha256 cellar: :any_skip_relocation, monterey:       "e312a93b827f28c47cdb442c7d0a53ad16ef41e0464eaed9ae694ce8fe452500"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0652d9ef3ca92d684028d81d8a4a3e0ae2412e581bca3f81d8025d77d82dab7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28517faceb34cefb544c6ae9b49f49b19b5a8cc4d116685e8085f2a27b6e686b"
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
