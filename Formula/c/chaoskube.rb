class Chaoskube < Formula
  desc "Periodically kills random pods in your Kubernetes cluster"
  homepage "https://github.com/linki/chaoskube"
  url "https://github.com/linki/chaoskube/archive/refs/tags/v0.39.1.tar.gz"
  sha256 "2228937790850075ca424bbfa221172fc0be0d1b3fb3c2d755dab7101945a5dd"
  license "MIT"
  head "https://github.com/linki/chaoskube.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8eb1211081d6b7d7290155174d1e461af3257ff5e21775dbcefbea57133ee1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52edd63c7cbceace82c6830e4344aefc6190f0a5f804407ddd1d044ff3a377cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bec75bdc3d2437328edbe087056053e188eee3099922ea3ed7912ae6ca08c43"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fa184e0297b5a30ce33e86c3c0b38a01d03e8f2148fdf89518b63dd89cae4aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11335c35530d5232d58fe944684c0379763eb754d15027505d8b03ee7fdad921"
    sha256 cellar: :any,                 x86_64_linux:  "6c79217bdc3e3dcbfa1e4eb5971d8e4cf73faa8f4f55e5484d3279d28b107b95"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/chaoskube --labels 'env!=prod' 2>&1", 1)
    assert_match "dryRun=true interval=10m0s maxRuntime=-1s", output
    assert_match "Neither --kubeconfig nor --master was specified.  Using the inClusterConfig.", output

    assert_match version.to_s, shell_output("#{bin}/chaoskube --version 2>&1")
  end
end
