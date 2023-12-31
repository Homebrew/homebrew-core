class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kwctl/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "7bf6ee53c3e27117122b5e025421b0fa606eab580197edae0eddf2e063709568"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18e8c00318b2982ba6bd0a34874a2387a9b3378a29eefe5365c9a4d67ec48724"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51170e33f9bc4fdda4ad01b076259736808e32673d677c429924c901c15156d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96d95faab71620ba1ec16af9724a0d2a33873f96d6ede5ed7f6a7ead83dbbf9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "4eba4e4e081b9add8aa343f9479a96aec2e9279b3927c19140041fb3fd762094"
    sha256 cellar: :any_skip_relocation, ventura:        "fbfaccc6da2ad37098c100cd7697de0fe5582054476924bd190e4d6e8a6bf91a"
    sha256 cellar: :any_skip_relocation, monterey:       "aa88d3369b6c39bc9e2315f8f7d8ee7de0aa72a2bb27915f10d7fa83c512e953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65b735e074f89a085fc50ad3c8f62818f5e9935036d805c6fdedbd5ff94ce4dc"
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
