class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.5.6",
      revision: "555030053825dd61689a086cb3c2da329419325a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8cb89e3036ef53a7fd7f028c209a2102849f9d10ded6c87889cbb9b08d128cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ec4ee479ba151b38c8c2dbcc61b13e4c20e03d5908f7bbc5eb370de7b520122"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b040eb0a84c4c1c71d349c3e20b142f939259a7b2575bd4d52c019439fb41a56"
    sha256 cellar: :any_skip_relocation, sonoma:         "59adea1107f9751bec1834819d9ca85d619c57bf47d97194bf4a9aea4d64bd37"
    sha256 cellar: :any_skip_relocation, ventura:        "0d1a4d8a6f82dc3964fde47f0cdcd2dd8d963a7ee858dd5aefffc3e6049767ba"
    sha256 cellar: :any_skip_relocation, monterey:       "74254138c7499118a13d0f6c77a5c36ede430cecfd4c541bdcd6c9e31f589639"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0181e22779c7892e0dc65122e8722752ad8bbee20f63543a8c070291d6887b46"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "dist/argo"
    bin.install "dist/argo"

    generate_completions_from_executable(bin/"argo", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match "argo: v#{version}", shell_output("#{bin}/argo version")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig ./kubeconfig 2>&1", 1)
  end
end
