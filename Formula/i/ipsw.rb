class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.600.tar.gz"
  sha256 "70a3ac51fe2490546cbc361c6cae9125c191d88b36ca432b77a3ffed3606a13d"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ad2d39344fd5b4eaf0ace3c1b358ab4404e24e591569967d83ad2b898e47ef5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba67ef80cbfcf96f202b93b87970a57a52ab1240ab4dc4bd3524a2bcd25451c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e63db21220b6602cb372a3cde3fcae339a7b38aa34cf50e8fca7b3afe91ae851"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd73eab39597d8f3e5bfc2ae261973fa987a748f3a3816e3a8dacac3937a510e"
    sha256 cellar: :any_skip_relocation, ventura:       "745ea90c65fd24e63bab74eff625457034a785f6279d4589d2929a8564a0779c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7e5e73c7af22445c7f50b71f0c859956d8f605fb3426f3ed46f4fd7a05c09a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0919a5abe70f38cede6d5377f91b21cf352068052c1b31cc119dde2b2848dea5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin/"ipsw device-list")
  end
end
