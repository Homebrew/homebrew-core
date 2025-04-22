class Humanlog < Formula
  desc "Logs for humans to read"
  homepage "https://github.com/humanlogio/humanlog"
  url "https://github.com/humanlogio/humanlog/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "ee74057578be0f3e4809310628ece7b3dd724ed289faeccbede7516ae9c0cccd"
  license "Apache-2.0"
  head "https://github.com/humanlogio/humanlog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e607ffb517b99483aff013387c964df57c8146e11ecc661bf216149aa28e99f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a5af5c936e226edd0e6ee87837c084f495ea60a5bc1dded1de2d60aadc12ef3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10adf72350923e7485caae7f36965120345115aaca4daf8988d6915bf3676a7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a5e445aa0ba11de61a37a66cff000a844dad842cf3a7ceb752555c41817a702"
    sha256 cellar: :any_skip_relocation, ventura:       "96974ab256db635fefbdbac3568b86432e92bace15f4c0df1ebacb4ebaa8d110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0d6c3ae2ac9f62c305f004c33732859b7868ad23251c4518924af4c104f848e"
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
