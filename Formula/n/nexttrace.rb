class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://nxtrace.github.io/NTrace-core/"
  url "https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "4af2896d5dcc18ecff3bd45f20728c6e848127608d080ebe47b07ed1212720d6"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f898f8232d62b849869128446d192d34aa106361c268d8691e6efb581494e0c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e97ed8f6fb27a22a991fc541159b03cafb143e562e316fe91322ce82dc61547"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30b603640d8286d518de7ae5d84da44e7b4aceb748fa46aee5ad552910902e64"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b59bde9c255fbe2a1ac178110b161d1a5e0011b3713fc3dfbf4a47c2798429f"
    sha256 cellar: :any_skip_relocation, ventura:        "efd7b55b638d5cd1300307f2850f1c60324bc9eb7898423419c470f3fc2148ff"
    sha256 cellar: :any_skip_relocation, monterey:       "74f430640230f7263fd489a7dd2de6dcc914c50a578224bc4cd0fafef8531245"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1087d7a336dbfc86916cda0350d1f3283b0009355877a9b9d7b65d6f8e1a0531"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nxtrace/NTrace-core/config.Version=#{version}
      -X github.com/nxtrace/NTrace-core/config.CommitID=brew
      -X github.com/nxtrace/NTrace-core/config.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  def caveats
    <<~EOS
      nexttrace requires root privileges so you will need to run `sudo nexttrace <ip>`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    # requires `sudo` for linux
    return_status = OS.mac? ? 0 : 1
    output = shell_output("#{bin}/nexttrace --language en 1.1.1.1 2>&1", return_status)
    assert_match "[NextTrace API]", output
    assert_match version.to_s, shell_output(bin/"nexttrace --version")
  end
end
