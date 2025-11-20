class Pug < Formula
  desc "Drive terraform at terminal velocity"
  homepage "https://github.com/leg100/pug"
  url "https://github.com/leg100/pug/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "e4a298523b450883be7bb3a9ab3f40c5d821ac88bd91d682093595c537a7f45d"
  license "MPL-2.0"
  head "https://github.com/leg100/pug.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "287f4c4179583f224f6727b0a652451e143097b41102fc7f25be59c134069e36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42846ed3a6a39b4a03222a858abe4d8c2e7997f897f7dcce63f1c14ac4dcc5f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42846ed3a6a39b4a03222a858abe4d8c2e7997f897f7dcce63f1c14ac4dcc5f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42846ed3a6a39b4a03222a858abe4d8c2e7997f897f7dcce63f1c14ac4dcc5f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "446973d6d7d50bd36a091955da5350479b69d92bd6adabea81cfaafdadecc04b"
    sha256 cellar: :any_skip_relocation, ventura:       "446973d6d7d50bd36a091955da5350479b69d92bd6adabea81cfaafdadecc04b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04b69c5aca4624ea65e4e1514689a7b8c00c93195a30868d8fb8849c1da6da8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "084b94edf9580a6e255587ed3b9745df7db27780feb351b31eb559e9a6157964"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/leg100/pug/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pug --version")

    # Fails in Linux CI with `open /dev/tty: no such device or address`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"pug", "--debug", [:out, :err] => output_log.to_s

      sleep 1

      assert_match "loaded 0 modules", output_log.read
      assert_path_exists testpath/"messages.log"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
