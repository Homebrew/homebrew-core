class Polaris < Formula
  desc "Validation of best practices in your Kubernetes clusters"
  homepage "https://www.fairwinds.com/polaris"
  url "https://github.com/FairwindsOps/polaris/archive/refs/tags/10.1.1.tar.gz"
  sha256 "bc53d4ffc7af26e2562b60593019392d20eb791c0557ab889a0e5e949e9b9561"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/polaris.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19031549ed861c09df5a734949e93a2f318fa67ce6ce6e98f1997e856440c897"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6129839c301d13e780c88c20ea79085acde63908747aae5e46d4a7659e6fad27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66fabebfa7ed67b9e254206576dfd5299c3f1d68887a339ed8fdbb964277614a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9358381eafd550f2d3f29868511f18a5231d70b165bb8c1ea5f388b3b8004df6"
    sha256 cellar: :any_skip_relocation, sonoma:        "00f99f2b9212b04c51f9d29d26c63207384cdd3c7be2486051d01190041d479c"
    sha256 cellar: :any_skip_relocation, ventura:       "b5ca614681dcff2e7ef60cc199f31492d842334dca5889f6774a6912b0a3bf5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a240ef4b373288ec3c6d20561acd04e3a3c7aa6d64027f0850fa323535b03b1e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version} -X main.Commit=#{tap.user}")

    generate_completions_from_executable(bin/"polaris", "completion")
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
