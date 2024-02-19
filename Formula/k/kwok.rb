class Kwok < Formula
  desc "Kubernetes WithOut Kubelet - Simulates thousands of Nodes and Clusters"
  homepage "https://kwok.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/kwok/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "3ed107a8f485610dc8fe3d7e8b327028855e9e0aca0c7bcf83ef3d18f6a834d7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "578079f6029fd1eda4761cc37829f551541f340ee6999e2a584f3cf4bafeceab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddb506fc8ca85714e50fbbc7d32ce14eae5a18442605c05e8e243c889aeb7f1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a255945e5303cd6ccd84128f1518f58f25385ffe3dd1029f471c4f905b0be84d"
    sha256 cellar: :any_skip_relocation, sonoma:         "15fda04c8ad55d34d406a3a9677c521002f5f125fb34adfbe9b10c69037b0641"
    sha256 cellar: :any_skip_relocation, ventura:        "062c41969317b40a3f46dac46a6b8cbd92c9b0e76a2343082265c79bf8cb9313"
    sha256 cellar: :any_skip_relocation, monterey:       "648de97c72649ec2fbcfae9fda6050600e714757cb218a89f5e9b63321b092c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b132f49b183e54bc6bfb571586e4cc242813e262208565cde1210be954ba15f7"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    system "make", "build", "VERSION=v#{version}"

    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    bin.install "bin/#{OS.kernel_name.downcase}/#{arch}/kwok"
    bin.install "bin/#{OS.kernel_name.downcase}/#{arch}/kwokctl"

    generate_completions_from_executable("#{bin}/kwokctl", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match version.to_s, shell_output("#{bin}/kwok --version")
    assert_match version.to_s, shell_output("#{bin}/kwokctl --version")

    create_cluster_cmd = "#{bin}/kwokctl --name=brew-test create cluster 2>&1"
    output = OS.mac? ? shell_output(create_cluster_cmd, 1) : shell_output(create_cluster_cmd)
    assert_match "Cluster is creating", output
  end
end
