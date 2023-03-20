class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v3.9.1",
      revision: "cbccafa75d58bf6ac84c2f5d34ad045980f551be"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6261700ad55bbb826bb6e2d2e635577f90d4b8955e94ddce95bdca7cfe5e9937"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92d905520a80675ce6a474787ef1d78860ab1433f4727889085a462575a86617"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "589af5dbdf89c8379b8924a80755abe2fd73ac39f9b10844c83e13446fad97df"
    sha256 cellar: :any_skip_relocation, ventura:        "85904ce288e95a66b5a9b592ad89b2606eae1a061d8bd4067bc1da7e2399a3e3"
    sha256 cellar: :any_skip_relocation, monterey:       "be8c48f02adcaaa9f7777c46799903ed71d0e8a5c41c5d21ffae81415a23478f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e28b1b7e6100d1e0a48e8fb791771a04d19a7c2aad7de51632af3bc908860713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94bc9cff679bbc23d9e2ca280c36c946a0d49b0c6e30589c208daaf2f35f9125"
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
