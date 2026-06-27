class KubectlExplore < Formula
  desc "Better kubectl explain with the fuzzy finder"
  homepage "https://github.com/keisku/kubectl-explore"
  url "https://github.com/keisku/kubectl-explore/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "cf13b9a569d5fb3852e6d6d6844e3f4383e4dbddfd16187eccd05627a4c10e90"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fff5a08cce8dd8ca15622ddccc271090a0ee0adbd0de46b500b784f8d9065bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7d6b640255911b9fa0b75d9ff9e7cf90a04efe360315763318b505a8b6ec526"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56c908416e6758381b3d6f5a98672bde474669e7be39295ac509740d962c4040"
    sha256 cellar: :any_skip_relocation, sonoma:        "53313c463727aebc3e3a5cded3dd859b633615aeb074fa4d9c0c77e7728381a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baf2b794b67a986bb850fb0aa2b364cb50bed6701b27a9ad5cf7ee710d15776b"
    sha256 cellar: :any,                 x86_64_linux:  "34b1c01450b1e59fe9a60a1786ea0b2b3111ddc61ad19f11ec9b3117d3b582a2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "The connection to the server localhost:8080 was refused",
      shell_output("#{bin}/kubectl-explore pod 2>&1", 1)
  end
end
