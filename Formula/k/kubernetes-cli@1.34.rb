class KubernetesCliAT134 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.34.11",
      revision: "3a634765b787dd069f7f714fa77d767cb7d43795"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.34(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d4c143e815a9fce0c1aca6f2b5b9d03307c8342de5e0a5e360b4176f70fa6fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64ccdbcbd9bbbf8c6fd58ce0c0dd6ecb34538ed31d4b90ab1b799bc7cb38de90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cb7a29800a775798e3022cb30d2d47f67d361adec3e5adac13209b3112c28a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "373910661bac1db0ff6b90f9a76e89a0cbdfaba85a23e1bfd503d44b1fcfdfda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20331723913e7abd4c1fc8a7d322e16618d7d30b2c54e40a3f841101aabda38e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb385480b0d1d5e75a70b52b1cc30a722964e38424f1ef06afff562b7dab83af"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-34
  disable! date: "2026-10-27", because: :deprecated_upstream

  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  on_macos do
    depends_on "bash" => :build
    depends_on "coreutils" => :build
  end

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" if OS.mac? # needs GNU date
    ENV["FORCE_HOST_GO"] = "1"
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    generate_completions_from_executable(bin/"kubectl", shell_parameter_format: :cobra)

    # Install man pages
    # Leave this step for the end as this dirties the git tree
    system "hack/update-generated-docs.sh"
    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client --output=yaml 2>&1")
    assert_match "gitTreeState: clean", version_output
    assert_match stable.specs[:revision].to_s, version_output
  end
end
