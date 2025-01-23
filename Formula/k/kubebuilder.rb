class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v4.5.0",
      revision: "7153119ca900994b70507edbde59771ac824f2d9"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "993566097f5a532d71ec30efbdfec453e7788d1929f2c04b46044b59d70385dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "993566097f5a532d71ec30efbdfec453e7788d1929f2c04b46044b59d70385dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "993566097f5a532d71ec30efbdfec453e7788d1929f2c04b46044b59d70385dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4b4d6865e56103be2ab2095c93dc41241cf6827ad978b1a13afc40acea883f9"
    sha256 cellar: :any_skip_relocation, ventura:       "d4b4d6865e56103be2ab2095c93dc41241cf6827ad978b1a13afc40acea883f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8fb23c6897c48c25009de20e296a9f1100f6586e9dddf5b6df90f98ef47191a"
  end

  depends_on "go"

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp

    ldflags = %W[
      -s -w
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

    assert_match <<~YAML, (testpath/"test/PROJECT").read
      domain: my.domain
      layout:
      - go.kubebuilder.io/v4
      projectName: test
      repo: example.com
      version: "3"
    YAML

    assert_match version.to_s, shell_output("#{bin}/kubebuilder version")
  end
end
