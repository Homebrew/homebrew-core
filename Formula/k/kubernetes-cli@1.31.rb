class KubernetesCliAT131 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.31.12",
      revision: "c1e5f4a23e5ff5587504fd75d2ab828ed7d0d373"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.31(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "116fdff9fb9a741821e7044aa49ae5f59fbf04db4df423a52f498b0bbd2b9539"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "276316f94599cbb5938260a0565d863d82b32fd40a5e33c2bf6cef49944a8111"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01faf029bf52e8b1176216bf11d1d6cd9bb5db08c01f393e47c7562a87e06cef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a01453fb1f2ddac8f7ec50f2cd60221541838a492933b94f6172c47c565a750b"
    sha256 cellar: :any_skip_relocation, sonoma:        "411a1aee51697aac7927bc7b5f97b8dc2dad0079c68aeff1169e12a99baad1e6"
    sha256 cellar: :any_skip_relocation, ventura:       "02d86e51fc3b75710fd4521870ed99a0c248d86e82d36a9806f6c3a630a873ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fdb65f071671efb5c64a675f095395664b90be0c4b1f8196806cf3b88de8ced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d38a188903b9ecc2559a47e9191136eb6a86fa628d3d6cb94cdbc66167bb8767"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-31
  disable! date: "2025-10-28", because: :deprecated_upstream

  depends_on "bash" => :build
  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  on_macos do
    depends_on "coreutils" => :build
  end

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" if OS.mac? # needs GNU date
    ENV["FORCE_HOST_GO"] = "1"
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    generate_completions_from_executable(bin/"kubectl", "completion")

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
