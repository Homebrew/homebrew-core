class Leetgo < Formula
  desc "CLI tool for LeetCode"
  homepage "https://github.com/j178/leetgo"
  url "https://github.com/j178/leetgo/archive/refs/tags/v1.4.15.tar.gz"
  sha256 "40525913af3a493d6ca8960ccc1d26efbaa006a331843b08f53eb6de23176661"
  license "MIT"
  head "https://github.com/j178/leetgo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a55d7ca55e7c21a440b394f7b867a62631beb0b1dcbc699357aff0ec19e1335"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ed210045aadae5747cb3f906df171431ad6977826a0f666305fd0d481778ef1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bcd2be8ba50dc2bb513d5d8e2fe4f6341a79f299a04c0e51d2c4ef9800ed5c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e1bf7464f09a589bad97c98b18b6e7f6114a8aaaa0e52f37223714d78bd77f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "39dd443fcad5d45c1d061f2480690061ba9976735f2af87f719e0f3aca3433ea"
    sha256 cellar: :any_skip_relocation, ventura:       "ed9cc946beb4dbf2406f56fa71080824b64ac6ca23e46535334aee2eaa9054a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f1f602ca34abbe6524d9fc5bf501c8e8b588d51bf510285f584e947c423594f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa8b2dd33a551c7edd4b1e89cd25e011fbdef83d8cb8441fa839e4d4e4903389"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/j178/leetgo/constants.Version=#{version}
      -X github.com/j178/leetgo/constants.Commit=#{tap.user}
      -X github.com/j178/leetgo/constants.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"leetgo", "completion")
  end

  test do
    assert_match "leetgo version #{version}", shell_output("#{bin}/leetgo --version")
    system bin/"leetgo", "init"
    assert_path_exists testpath/"leetgo.yaml"
  end
end
