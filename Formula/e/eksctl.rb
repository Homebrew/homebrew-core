class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.221.0",
      revision: "de9424a29cd8108ff4574d54844e4e98175efac8"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80d034119116a40619116ba7c9474da06a554b5dbddcda25fad58f4e6444bbb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "420b60223dd3eb234cdde4a005db8adec5333be68a55d794ae72bd3116bbacdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35b524a23b26488a91be9e0e5edef48fb13415fc5b26ff2d57761eda20690680"
    sha256 cellar: :any_skip_relocation, sonoma:        "b29f11ee483d1f9f604e6550889526bd0bd7ba5309691b51b068219ba7b0cbd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "137f459eaa6fed4ea10f8daf0b54f46a3ac004cea47f4b755cc46e4be694e499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9fcefab5e54d1ef4d61376c7ff8519adab8b9bf59a2cc31f66483886724d217"
  end

  depends_on "go" => :build

  def install
    system "make", "binary"
    bin.install "eksctl"

    generate_completions_from_executable(bin/"eksctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
