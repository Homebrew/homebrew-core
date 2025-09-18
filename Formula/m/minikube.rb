class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.37.0",
      revision: "65318f4cfff9c12cc87ec9eb8f4cdd57b25047f3"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1de992e28c904537e9bb7291e2c058e4b0f896a191bca819a4b56044247b640c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d3cd0c4554207047cdce1efddd7da706ad078646848a8198714afb6e375cfd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08b30541e8aa4dece8d30a515a88162bfc4c7b5916e0f682be21303fcdd4ee8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3da9522694365cf193988a29bedcd8d4fcd430c51f20d16bb3124d48acb73a87"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f7c49135a7d22a2954a3335019f9edaa7efb7dc3ec36a39c8611d74cca0a328"
    sha256 cellar: :any_skip_relocation, ventura:       "4a99e8fdb976b8d77d0236724f4234d339e578d65f2cdcfdfe021777820b4e61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be418b1b637fb4a224e784771903d8632fefdc524a88123700c83072cdb9cde5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f41f1fd1112d6d4badf73883e1d48f7d69fa6cc70af14fb1daa5994123a80e79"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "make"
    bin.install "out/minikube"

    generate_completions_from_executable(bin/"minikube", "completion")
  end

  test do
    output = shell_output("#{bin}/minikube version")
    assert_match "version: v#{version}", output

    (testpath/".minikube/config/config.json").write <<~JSON
      {
        "vm-driver": "virtualbox"
      }
    JSON
    output = shell_output("#{bin}/minikube config view")
    assert_match "vm-driver: virtualbox", output
  end
end
