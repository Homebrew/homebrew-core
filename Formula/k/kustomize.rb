class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize/archive/refs/tags/kustomize/v5.4.2.tar.gz"
  sha256 "3c2c24971b29d96aac43853c090a5f042789d169bd41cbd9738c7979c5f09deb"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a08864647d906f488393f86d4f9460fe84205f831e093fea94177a0dc10b1fbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0cd4fdd6c552fdad8d9216c229f7688ac429ac15bd337ef0374f777d42d05939"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e8d1359309d9e5b42a536ba23a5ee164ac53f69c199c6b1a1776ffb7325b076"
    sha256 cellar: :any_skip_relocation, sonoma:         "d632b6184c030de95e6931ee8589ecac47f44ed02e93d974312e375612e44e91"
    sha256 cellar: :any_skip_relocation, ventura:        "809810cb012518f874da947a439cda16db7b75a812187e54a995190760ebfad4"
    sha256 cellar: :any_skip_relocation, monterey:       "2f9874863c0ecefbb33e8b9424bc96c3a9ce57b8992fe73a7bc8bd570340f6d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43618dcedeec52f77b0fe079fb84ad67a7fd890900ceb4e07fed3683cb2ff23b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/kustomize/api/provenance.version=#{name}/v#{version}
      -X sigs.k8s.io/kustomize/api/provenance.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./kustomize"

    generate_completions_from_executable(bin/"kustomize", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/kustomize version")

    (testpath/"kustomization.yaml").write <<~EOS
      resources:
      - service.yaml
      patches:
      - path: patch.yaml
    EOS
    (testpath/"patch.yaml").write <<~EOS
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        selector:
          app: foo
    EOS
    (testpath/"service.yaml").write <<~EOS
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        type: LoadBalancer
    EOS
    output = shell_output("#{bin}/kustomize build #{testpath}")
    assert_match(/type:\s+"?LoadBalancer"?/, output)
  end
end
