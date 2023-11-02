class Chaoskube < Formula
  desc "Periodically kills random pods in your Kubernetes cluster"
  homepage "https://github.com/linki/chaoskube"
  url "https://github.com/linki/chaoskube/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "af0d33bda0f0d0f2be5c87f1d5e72353f815ea88ddc34575b7a71e2a146b620e"
  license "MIT"
  head "https://github.com/linki/chaoskube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3309cbf4c66214cf5a397c7ee2db73378ba00b57010d444afc3f918b6a189ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "130d75cc071506659d6c8de6d00f643c22b8efdb216d57c627f093daa4183984"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44e1cb5c2180ef441c22e085f5a23201b6273bf0354b3ba276e4e30ecda54f00"
    sha256 cellar: :any_skip_relocation, sonoma:         "cad91317bbc3431d50f4fba847d95a7273ee5c4b6dbc4e0a0df626c644cbf054"
    sha256 cellar: :any_skip_relocation, ventura:        "19703e0a3c4cb750cb238bed3fac912de4be0591ee54e54f155ca5ba42e9b22c"
    sha256 cellar: :any_skip_relocation, monterey:       "038c05095f5849cf7fd6be37eb546db3aa959de9b7100507b44e23616e8b6cc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0f65d8e6c5ec3940c1f91728295c6fb130cd6111283bfeb91247c086876a2bd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}/chaoskube --labels 'env!=prod' 2>&1", 1)
    assert_match "dryRun=true interval=10m0s maxRuntime=-1s", output
    assert_match "Neither --kubeconfig nor --master was specified.  Using the inClusterConfig.", output

    assert_match version.to_s, shell_output("#{bin}/chaoskube --version 2>&1")
  end
end
