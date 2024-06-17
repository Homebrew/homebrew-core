class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v4.0.0",
      revision: "6c08ed1db5804042509a360edd971ebdc4ae04d8"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5b072f2281c3b0196d1bdd44bebe0d3b73a1c15fe1637f49b06f3b83801dcd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c62aefe0f731f9d8c2b1b10c11459786e5d7656663faf4c646a202849b2f115e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e3e3634126ad6a3939dc99d2f9fac75a7eec3c032352576ce18c320abf55597"
    sha256 cellar: :any_skip_relocation, sonoma:         "ccdd5deb4038f5787e7afe5a4558a150248d9643ab0be02588e2185adf9425e9"
    sha256 cellar: :any_skip_relocation, ventura:        "0f15baa80c6782c33e8bd509492546a68bba5a9d9f790a6ab944d4afc71e88c4"
    sha256 cellar: :any_skip_relocation, monterey:       "1d952f19072768671a780bb93b01e359f92828619dbd9f3a1ad34dc9a18728b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b43a1cdaca2bcb973c320c58c443562110cec75a44cabedba87bc00a96aa049"
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
