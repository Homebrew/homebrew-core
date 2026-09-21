class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://www.nxtrace.org/"
  url "https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "b598e678dda47ac1c7d598bd39ac36089252ff773912abfdcb14ba3fffd2e1cf"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3554432ed87c201444a0980f1db3cac14258a271a0509d22a59354f4c9a8973a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bd033db30a430fac16d42da06c714a4961aef073d2a70dc0301c9b9718490d6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0a8492778ee0b8baaee2962548b7a33702bad6b85fb7b8d9435cc2d6de8d7551"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "3963868c368537c4d4443f22c7983ea63767e68b14421f3695c810c0662d860d"
    sha256 cellar: :any_skip_relocation, sonoma:            "727a9038c11d191d1d2ae9ad18adc6063dd7c6c9535074ce3dfc0065b695b613"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3816551f795a8544eaa8547b1165bb811665811c4809912fdc16ac31195ff8a6"
    sha256 cellar: :any,                 x86_64_linux:      "5490dbae0637953d3442ee6072aa9498d59d7042b888fb1f58bc39493ac1e7e6"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/nxtrace/NTrace-core/config.Version=#{version}
      -X github.com/nxtrace/NTrace-core/config.CommitID=#{tap.user}
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

    assert_match version.to_s, shell_output("#{bin}/nexttrace --version")
  end
end
