class Humanlog < Formula
  desc "Logs for humans to read"
  homepage "https://github.com/humanlogio/humanlog"
  url "https://github.com/humanlogio/humanlog/archive/refs/tags/v0.8.8.tar.gz"
  sha256 "09d3e632bc10950bd917e248b1c52359f8ea4b164a8ab128e9b58e90724bae54"
  license "Apache-2.0"
  head "https://github.com/humanlogio/humanlog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da95c68b585cb62fc345997b178867646602974986bf2ff3388db622eed56685"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cca96c12e99ffde853524ebd8c7f1baddae830d3b2553472441319380178bd0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4563aa1caad424851b745915d4cf2afc7ced2d2e1276a4e953f9bf9fe33cf625"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "868b1292e09ac1ebd0ed3419460947e863071028c5230577757d9509a6845886"
    sha256 cellar: :any_skip_relocation, sonoma:        "b406178087c1f7af0bb8fc5620292e2ce7658831624294ee6e371afdda8907ef"
    sha256 cellar: :any_skip_relocation, ventura:       "b313bd0d0f8bc4b14ba744979065983358bea554154c0c4e71b832f8faffe2b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9fe12af518863f6786f078f895e46e1d87e87f2911723c1f675471a2fad899e"
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
