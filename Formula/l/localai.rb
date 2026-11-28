class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/releases/download/v5.0.1/LocalAI-v5.0.1-source.tar.gz"
  sha256 "d2ca736513a89a56761e5ba5d1c9659db177ad605855cb3b66a94b61d5a559f7"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    manifest_sha256 "92a3e2a7c699a2391208c41bfe3337c7163c05a0b0c1a9e8011831a2f7305ae8"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b46ebaed77089a4867f52439ac0a7ec159d91abda10d89f494ade8776a77a3d9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fa50ea17d435592cb16fa26556b203358185da243d35a47efbdcd55a81274d9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2e1c7b1795752954a25cba8f4ae3a9c5af012cd5d5277d9a83c4449c83090248"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5506bf3978f0489e84d8d757878cd80d6caae96f13b4c1506178d1044c059a94"
    sha256 cellar: :any,                 x86_64_linux:      "a8acbbff5fa8aaf434968a00b4e65f14db86407a6516b86944714aa960ae89ed"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "protobuf" => :build
  depends_on "protoc-gen-go" => :build
  depends_on "protoc-gen-go-grpc" => :build

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    system "make", "build", "VERSION=#{version}"
    bin.install "local-ai"
  end

  test do
    addr = "127.0.0.1:#{free_port}"

    # The add-on owner opens `/` at startup, which the Linux test sandbox denies
    with_test_process(bin/"local-ai", "run", "--address", addr, "--addons-enabled=false") do
      sleep 5

      response = shell_output("curl -s -i #{addr}/readyz")
      assert_match "HTTP/1.1 200 OK", response
    end
  end
end
