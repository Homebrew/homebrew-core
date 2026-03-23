class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v4.13.0",
      revision: "bb95ce240477f3d9be177b8c8f40d4876a618f45"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2af3e1d229e6b126e0d484c7228858623cf9d96d47c58e0744c8a27ac2fbec26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2af3e1d229e6b126e0d484c7228858623cf9d96d47c58e0744c8a27ac2fbec26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2af3e1d229e6b126e0d484c7228858623cf9d96d47c58e0744c8a27ac2fbec26"
    sha256 cellar: :any_skip_relocation, sonoma:        "e87acc3e0a364ab877708213df459d672bd32e3795d311d16a77020d842aa07a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe95c0c792d33ca88b9efa052dc83cda658edd987d20ea1598f57a27b1199945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "975de8d99da307fbc0d0c99961773a9c2ada953b2c5a6ff8e5c31c915e555996"
  end

  depends_on "go"

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp

    ldflags = %W[
      -s -w
      -X sigs.k8s.io/kubebuilder/v4/cmd.kubeBuilderVersion=#{version}
      -X sigs.k8s.io/kubebuilder/v4/cmd.goos=#{goos}
      -X sigs.k8s.io/kubebuilder/v4/cmd.goarch=#{goarch}
      -X sigs.k8s.io/kubebuilder/v4/cmd.gitCommit=#{Utils.git_head}
      -X sigs.k8s.io/kubebuilder/v4/cmd.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubebuilder", shell_parameter_format: :cobra)
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
