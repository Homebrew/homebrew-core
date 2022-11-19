class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v3.7.0",
      revision: "3bfc84ec8767fa760d1771ce7a0cb05a9a8f6286"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d801c6c5b5fdf7b6e17fc390385c8b6a2087b99b6cc23bbfae7749fbcc9ddae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed28191bacb910531974baced46d2a50a817db3aa2975d7758be7826c735f51d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e863ba2dec79a6c87a9f93224eb7699fe949d4efe032795a6ba63235cc1c149"
    sha256 cellar: :any_skip_relocation, ventura:        "f670be76db2b533c67b52408ff5c8f4ee632378ae54c89bcaf9a85ddb754d4f5"
    sha256 cellar: :any_skip_relocation, monterey:       "ca43e24cbbcbe43df28bb4720e9e3019b72d50adf43d56a208eb2c1dc26fb736"
    sha256 cellar: :any_skip_relocation, big_sur:        "abb89e465db3532431a36cbe3f8f4ce9a689a7b879adcf3adeb22f94c9b603b4"
    sha256 cellar: :any_skip_relocation, catalina:       "e3c813ad5736ad5651d0e4e46f862d5121e4637a6732aeefed227d7daa0e8130"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "828c05bdf24153cabb7233ca2c065a24f935bb598dfce67e522ca7913e0b91fe"
  end

  depends_on "git-lfs" => :build
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
