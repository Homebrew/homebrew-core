class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://nxtrace.github.io/NTrace-core/"
  url "https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.2.8.tar.gz"
  sha256 "39c1f0f5c0ec7c94b6b476c1ec64e3ab2971c5444ffe6318b2e233c2a5d2e924"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63fe7bda5b7e6ca55cf9d8edf216f6a9958c54f9a8fd375f8955b520984d2627"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83357e107d95566ae244873cae7ea6f8e559820e1fd11e984ceebe1d0f985c25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0b673449d2c8ccb7f9ef25087a26fdf4ab97c7706f23756e568d924cd4c965c"
    sha256 cellar: :any_skip_relocation, sonoma:         "4552e9e177dd985ed2cb6236ef9d15a37337bef57a7d10d83b619b5b2870a22f"
    sha256 cellar: :any_skip_relocation, ventura:        "099999f34e35fa29eba8455b6b737a38ff3ebd42198a78e92a043f6728f87148"
    sha256 cellar: :any_skip_relocation, monterey:       "ec604d702a7cb2b4f4dedb20ba94a119873eacae03323acff78a28f8f0cc393d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b47400c61551ea7b3aef4f79b75d3e8626f3102b98d2dc27441fd177e7985de3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nxtrace/NTrace-core/config.Version=#{version}
      -X github.com/nxtrace/NTrace-core/config.CommitID=brew
      -X github.com/nxtrace/NTrace-core/config.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
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
