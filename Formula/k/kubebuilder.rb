class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v4.2.0",
      revision: "c7cde5172dc8271267dbf2899e65ef6f9d30f91e"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0d111447850cc6b4143bee6ea02a7b3e0cae325d90bcb6fcc18ac46c0e1c18f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73a57fd8b5d0deeb081bf01ef6753ba8e6231d0bb80aafb824efbbf00f0625f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73a57fd8b5d0deeb081bf01ef6753ba8e6231d0bb80aafb824efbbf00f0625f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73a57fd8b5d0deeb081bf01ef6753ba8e6231d0bb80aafb824efbbf00f0625f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa236123d554acf17ec671b3053b8eb5e753cd1b0cf94116baeb608d6d32ed90"
    sha256 cellar: :any_skip_relocation, ventura:        "fa236123d554acf17ec671b3053b8eb5e753cd1b0cf94116baeb608d6d32ed90"
    sha256 cellar: :any_skip_relocation, monterey:       "fa236123d554acf17ec671b3053b8eb5e753cd1b0cf94116baeb608d6d32ed90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0512a456e48b127621cb99afdf314f30e15034550c0a04381eaea509329f124"
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
    system "go", "build", *std_go_args(ldflags:), "./cmd"

    generate_completions_from_executable(bin/"kubebuilder", "completion")
  end

  test do
    mkdir "test" do
      system "go", "mod", "init", "example.com"
      system bin/"kubebuilder", "init",
                 "--plugins", "go.kubebuilder.io/v4",
                 "--project-version", "3",
                 "--skip-go-version-check"
    end

    assert_match <<~EOS, (testpath/"test/PROJECT").read
      domain: my.domain
      layout:
      - go.kubebuilder.io/v4
      projectName: test
      repo: example.com
      version: "3"
    EOS

    assert_match version.to_s, shell_output("#{bin}/kubebuilder version")
  end
end
