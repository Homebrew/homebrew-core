class Polaris < Formula
  desc "Validation of best practices in your Kubernetes clusters"
  homepage "https://www.fairwinds.com/polaris"
  url "https://github.com/FairwindsOps/polaris/archive/refs/tags/v10.2.0.tar.gz"
  sha256 "bec96d3e968eec77a4f60c2b9d7c6a4fa949c3c667807309c2ff6af1a022ece6"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/polaris.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dacb76f5a75fcb9b81a5182abeabde806aaa8ca6b71078aa03343ec08394ba14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a25fcc846ad751e25eb2d6e9b6b04f2e1fe8e207f1f9ba8394e4262b31d58cd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "542841012d9eb9ffaa9797313f94b6ad06713674ac8fef90fd625d4cc3d50bab"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb822411f5db4236cfe0f4326dcdbdb9d51a02a406fe663a141b0773fedb7afa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc61b0d93ea9608f5061d9a28a35eb8ac616b10c964a1681ce3d00d059d4029c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9183ca87a269aa8077935a7827cd7752bc22063116eec4f3d3e26b9b9aa43e7d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"polaris", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/polaris version")

    (testpath/"deployment.yaml").write <<~YAML
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: nginx
      spec:
        replicas: 1
        selector:
          matchLabels:
            app: nginx
        template:
          metadata:
            labels:
              app: nginx
          spec:
            containers:
            - name: nginx
              image: nginx:1.14.2
              resources: {}
    YAML

    output = shell_output("#{bin}/polaris audit --format=json #{testpath}/deployment.yaml 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
