class Polaris < Formula
  desc "Validation of best practices in your Kubernetes clusters"
  homepage "https://www.fairwinds.com/polaris"
  url "https://github.com/FairwindsOps/polaris/archive/refs/tags/9.6.4.tar.gz"
  sha256 "f2ba54978d8ffef3ed19194e20ba41f3cc76ab8f834fc1c159d33e4cb9caedde"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/polaris.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ef434ef6cd56dd69897c9e5590bd70733a70857470aead4e5d75ef7d75af424"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12a13e874ac79ea28466cc460ccdec0d5fa8591979856a727121c29d3bd11292"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "01c6ec3b5a1e06fb4dc08cb37c9716d718ac0c097954b146499c675296164567"
    sha256 cellar: :any_skip_relocation, sonoma:        "d572ca9715d04611af9a9b350704f10e2ce005c7b7487b0f3d2f5641c568ec07"
    sha256 cellar: :any_skip_relocation, ventura:       "c46b43399918f99ba929cf8dda7bbb5735ed390d671c3e18939927f53657af4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "516d84c856928570edde9fe8aabe7d2e4cdc488029e34f41a6b4938da2cf5931"
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
