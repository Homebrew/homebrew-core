class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.51.1.tar.gz"
  sha256 "b4310365bce6544edf63cf446a725f1e653c8cc78126053375d2af7fa9b43197"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "338b532fb7f467abe5317db056760181d439fecac44c90d81bf83edf22cee9b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "338b532fb7f467abe5317db056760181d439fecac44c90d81bf83edf22cee9b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "338b532fb7f467abe5317db056760181d439fecac44c90d81bf83edf22cee9b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "17c34659bd7c64b3f126e0069f175224a00dc6d710bae749633277a8f157ee7b"
    sha256 cellar: :any_skip_relocation, ventura:       "17c34659bd7c64b3f126e0069f175224a00dc6d710bae749633277a8f157ee7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a1f70bf973ea95473c26046937cdba587de261a9e4011ce534b0ec1153169b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9592e5ec2356052780c256523fcd16ccaac268589990dc3968c921fd46e2eba"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ekristen/aws-nuke/v#{version.major}/pkg/common.SUMMARY=#{version}
    ]
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "pkg/config"

    generate_completions_from_executable(bin/"aws-nuke", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-nuke --version")
    assert_match "InvalidClientTokenId", shell_output(
      "#{bin}/aws-nuke run --config #{pkgshare}/config/testdata/example.yaml \
      --access-key-id fake --secret-access-key fake 2>&1",
      1,
    )
    assert_match "IAMUser", shell_output("#{bin}/aws-nuke resource-types")
  end
end
