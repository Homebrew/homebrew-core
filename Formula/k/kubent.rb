class Kubent < Formula
  desc "Easily check your clusters for use of deprecated APIs"
  homepage "https://github.com/doitintl/kube-no-trouble"
  url "https://github.com/doitintl/kube-no-trouble.git",
      tag:      "0.7.3",
      revision: "57480c07b3f91238f12a35d0ec88d9368aae99aa"
  license "MIT"
  head "https://github.com/doitintl/kube-no-trouble.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f8207dfcf047d8e851f69cc9d59e13b0310f9af72b7641ba7163524f46f78da7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "68db3486daaf6ba9c4a84482b1592bff93a67767d0b12b2766d09619a65e1691"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13d2768c1c54c75eb61b9509441b74a2046fb0e296f7e4186a5123250a74d61c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13d2768c1c54c75eb61b9509441b74a2046fb0e296f7e4186a5123250a74d61c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13d2768c1c54c75eb61b9509441b74a2046fb0e296f7e4186a5123250a74d61c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9f9a862ec8458c562ec9643e4c6876475d1e77071730f2c6876b29403d641f1"
    sha256 cellar: :any_skip_relocation, ventura:        "b9f9a862ec8458c562ec9643e4c6876475d1e77071730f2c6876b29403d641f1"
    sha256 cellar: :any_skip_relocation, monterey:       "b9f9a862ec8458c562ec9643e4c6876475d1e77071730f2c6876b29403d641f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "cbc3d5e73162945f8edd742a5f1716b03405c10186c7d8c4915c8fd53e9a0f41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a54e603d5dca3dd7c708ce765318b460eef6b5ca4407a28356edc0c16ae2bbe"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitSha=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kubent"
  end

  test do
    assert_match "no configuration has been provided", shell_output("#{bin}/kubent 2>&1")
    assert_match version.to_s, shell_output("#{bin}/kubent --version 2>&1")
  end
end
