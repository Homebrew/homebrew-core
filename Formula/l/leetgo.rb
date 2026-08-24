class Leetgo < Formula
  desc "CLI tool for LeetCode"
  homepage "https://github.com/j178/leetgo"
  url "https://github.com/j178/leetgo/archive/refs/tags/v1.4.18.tar.gz"
  sha256 "6268de85aec3acf4db6fbe76b39a033dcc166d2ce1e8dc5304f603d60a5994eb"
  license "MIT"
  head "https://github.com/j178/leetgo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a99853980ea02580a158f8168f0470bc3481e8a4250ee7feb048130827cc908"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7fc64ed28c8c787d9cfc2974a59959a5152501a11e41c63ad1ed018c9f272a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c45c4b06f6d6265eb9ecd6a4c6ef46de6e7467f3e33120a2818cc7732f7ac29e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e729850bdf691f56999ba588dfce6cc0742c035b2749701db7581a936fc675e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43ecd167ba7342b5041e8b5be52b35a6b01ee0b182016c0677781fcec00b9afb"
    sha256 cellar: :any,                 x86_64_linux:  "0093263f77bc9f1890e826bf31748e5751ecb575f58eefb14f8cc5d21c5fa23b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/j178/leetgo/constants.Version=#{version}
      -X github.com/j178/leetgo/constants.Commit=#{tap.user}
      -X github.com/j178/leetgo/constants.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"leetgo", shell_parameter_format: :cobra)
  end

  test do
    assert_match "leetgo version #{version}", shell_output("#{bin}/leetgo --version")
    system bin/"leetgo", "init", "--site", "us"
    assert_path_exists testpath/"leetgo.yaml"
  end
end
