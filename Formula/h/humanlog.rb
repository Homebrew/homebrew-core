class Humanlog < Formula
  desc "Logs for humans to read"
  homepage "https://github.com/humanlogio/humanlog"
  url "https://github.com/humanlogio/humanlog/archive/refs/tags/v0.8.9.tar.gz"
  sha256 "7eb257742d52bd292f61312414af49e85acfe3be6fc687c391fa5fbb8e9e08d4"
  license "Apache-2.0"
  head "https://github.com/humanlogio/humanlog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e202bd633ce912f0e918947e902bef0993a7fdbbe6dc53da6643c9029a2558cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f9a2fb9f23340ff662d481941a9956ee19a09621eba93da80858dc0bc84bd1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "863588c31724ab74513537910c5d27a6e926e14070e0d8c158c8f1ac616f3af3"
    sha256 cellar: :any_skip_relocation, sonoma:        "180b1362082f79196e1fd26670086154c37190b82fcd4deac1cf9d9d1514d9ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4699cfbc7390d82908f8eb83f04d509f31ed02d338af18a183fb9ba341ad3a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f28a25ed68a154c0a8f29ff9116691c2882bc9e33ecb5feea1f3bfda1ab1d33b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.versionMajor=#{version.major}
      -X main.versionMinor=#{version.minor}
      -X main.versionPatch=#{version.patch}
      -X main.versionPrerelease=
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/humanlog"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/humanlog --version")

    test_input = '{"time":"2024-12-23T12:34:56Z","level":"info","message":"brewtest log"}'
    expected_output = "brewtest log"

    output = pipe_output(bin/"humanlog", test_input)
    assert_match expected_output, output
  end
end
