class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.31.2",
      revision: "fd7ecd9c4599bef9f04c0986c4a0187f98a4396e"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4132eb40453ba2fe36f55d95317f1e9af77c1cab819c6a3370cece89d3da6f2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bcecf8591a42a0b48549b23f82c9ea52656b492c91c2616d6a679cb2298ef7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "118b3b28b0f358cb432e05faaa689fedfae49b77c80dd6aa557ab87fbad2e58e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1eeb2229664c4d98787a0221245f41c729af9613b0456de4c1f62f04514fef57"
    sha256 cellar: :any_skip_relocation, sonoma:         "5721d8f7cc97486e5aa115268221fb8ca8919f4710c8d5047a380b6414e7b87e"
    sha256 cellar: :any_skip_relocation, ventura:        "b48d6b05f50bb6932e82281293e9399aec4680cd5759f0f512918cd1bc13ed8d"
    sha256 cellar: :any_skip_relocation, monterey:       "36e2470f3ac22319dfdc649d989b9ee0f5bc8bc80f141175baaf40db5f245c8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "cae04bbd5001f5bbf2816182709c8122d11f01766d5796bacc4df740063769bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df804daebf62248fdc3ded276246d39805f8f80caef08b713172d734e64bdc7e"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "kubernetes-cli"

  def install
    system "make"
    bin.install "out/minikube"

    generate_completions_from_executable(bin/"minikube", "completion")
  end

  test do
    output = shell_output("#{bin}/minikube version")
    assert_match "version: v#{version}", output

    (testpath/".minikube/config/config.json").write <<~EOS
      {
        "vm-driver": "virtualbox"
      }
    EOS
    output = shell_output("#{bin}/minikube config view")
    assert_match "vm-driver: virtualbox", output
  end
end
