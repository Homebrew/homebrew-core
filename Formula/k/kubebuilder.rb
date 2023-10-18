class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v3.12.0",
      revision: "b48f95cd5384eadcdfd02a47a02910f72ddc7ea8"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b503e0fd52816fcdb7c733a690a79fc608544ee2a3bf223370a0f811f3369d30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9a11939a84eef740632a2a6db6011ad1fb1a8d87d23f15090ca8037ca9e39a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb99c6089ebc567b91081e9836381e1d16f9ae87d439ebe975c81ec9fd62f49b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d30a64b127570182be27ba37792557747f8ccbd4e05a1a8714f44711049e70f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d24e0a7437bb57df990dc9cd93176dee84f60634eb690d6dd12c6f4948e76bf"
    sha256 cellar: :any_skip_relocation, ventura:        "63368cd294318f2bd07f83f58ea777799b42b18ef71d3857ef709a18fd563484"
    sha256 cellar: :any_skip_relocation, monterey:       "2800b504d7fe1936e62cba74bc60425191095669d11d5b6f77c427bb2e0929c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "302732d171970744beb31dfc592e097c985bd01fe1c3c386f324eae7ba5f0280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "276b872be8885ad5e99a909098a04e3633ed5ec223fbe2706efb6a31920c3b5c"
  end

  depends_on "go"

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp
    ldflags = %W[
      -X main.kubeBuilderVersion=#{version}
      -X main.goos=#{goos}
      -X main.goarch=#{goarch}
      -X main.gitCommit=#{Utils.git_head}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd"

    generate_completions_from_executable(bin/"kubebuilder", "completion")
  end

  test do
    assert_match "KubeBuilderVersion:\"#{version}\"", shell_output("#{bin}/kubebuilder version 2>&1")
    mkdir "test" do
      system "go", "mod", "init", "example.com"
      system "#{bin}/kubebuilder", "init",
        "--plugins", "go/v3", "--project-version", "3",
        "--skip-go-version-check"
    end
  end
end
