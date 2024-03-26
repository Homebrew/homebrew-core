class Cntb < Formula
  desc "Contabo Command-Line Interface (CLI)"
  homepage "https://github.com/contabo/cntb"
  url "https://github.com/contabo/cntb/archive/refs/tags/v1.4.10.tar.gz"
  sha256 "f1434b7c7032289c4ea0de0b46f6d26d874f7ce95d6bbb46e1784b019544dc4e"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "016092ad5092972f88b02a951dbe8fa8aecc20aa0f9ee3a1e6760a1b3cce6752"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "305707ebaad71801ccd6c4f8a5f8d51ce6a3038edf8a83a900b20be6ec3d6ad9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3465361798c5abeafafec2211f2c1ad478eb2959a54206ba87f7efd13308e94"
    sha256 cellar: :any_skip_relocation, sonoma:         "995d19aaaa1dbfba822b8fa8340054d4fd8421ff4c73d138f304c9cd8ab83703"
    sha256 cellar: :any_skip_relocation, ventura:        "f0b2b9b11f61469c25e9a8be90d2b8b2433ddb538853a1c5de0d385c8c8cf2ad"
    sha256 cellar: :any_skip_relocation, monterey:       "91081b3c7f431652cfe6151f903678d50d6ac7e4c0f92a7bacc6b9e8995bd482"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d59efbe6e2bc937e898c0418eeaf3ef4666d53a9e4244236715c014906ae5be"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X contabo.com/cli/cntb/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cntb", "completion")
  end

  test do
    # version command should work
    assert_match "cntb #{version}", shell_output("#{bin}/cntb version")
    # authentication shouldn't work with invalid credentials
    out = shell_output("#{bin}/cntb get instances --oauth2-user=invalid \
    --oauth2-password=invalid --oauth2-clientid=invalid \
    --oauth2-client-secret=invalid \
    --oauth2-tokenurl=https://example.com 2>&1", 1)
    assert_match 'level=fatal msg="Could not get access token due to an error', out
  end
end
