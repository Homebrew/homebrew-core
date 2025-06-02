class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.607.tar.gz"
  sha256 "1089af56736d79ae6da008dce8c9299930850ce69dbab5d11ac54f2f78db83cd"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "796e921266a35d7e5e321cc1df43987d43a33f47b9493419c6d56a7721bd2698"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fd354d1d407d8b4f6a992114c3da27a538210a5f69487d7b6e56fdfec4f57a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "edf9d9513bb95ecaa320320beecb7610e819ff2da81603b6a78611b226e2f7de"
    sha256 cellar: :any_skip_relocation, sonoma:        "16cfb67e250634a40ce37937e84f7c93831e817c93a903bd9b56ad5964142373"
    sha256 cellar: :any_skip_relocation, ventura:       "7430d2932246facc40f498553b946adbbd1e125127a49daa6676904421e1ba41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73b6abe9b208c5d74217b7b175fd08fcad2d5d969cf612bfceda2bb6cd64a3dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8ba997e31dff2cc3565cfd8093829159dd7eed0b51cc5dfe4f3ad0e158681e7"
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
