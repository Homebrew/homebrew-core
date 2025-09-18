class Ov < Formula
  desc "Feature-rich terminal-based text viewer"
  homepage "https://noborus.github.io/ov/"
  url "https://github.com/noborus/ov/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "e143cb8c817f68ac3737bdce0a7b098cbf0243a9d8274600f646686d867c70e5"
  license "MIT"
  head "https://github.com/noborus/ov.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1314b1576d52ae4eb6bf1fd97c682d44386b738712674c12d8f147e73d43024"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9053e18bf72c956ef949f97b3d2f4f072aae8790313f0b7fe11affe39d2432f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9053e18bf72c956ef949f97b3d2f4f072aae8790313f0b7fe11affe39d2432f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9053e18bf72c956ef949f97b3d2f4f072aae8790313f0b7fe11affe39d2432f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d177c5773ec508f02fe5e73bb1abca149007ba3562218753463bd43d0f02e1c"
    sha256 cellar: :any_skip_relocation, ventura:       "5d177c5773ec508f02fe5e73bb1abca149007ba3562218753463bd43d0f02e1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d3de36c5bde09fddc75255b9cfb4f5f189e564d1e8996bb66d5b24684349d54"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ov", "--completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ov --version")

    (testpath/"test.txt").write("Hello, world!")
    assert_match "Hello, world!", shell_output("#{bin}/ov test.txt")
  end
end
