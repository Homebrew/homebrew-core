class Boring < Formula
  desc "Simple command-line SSH tunnel manager that just works"
  homepage "https://github.com/alebeck/boring"
  url "https://github.com/alebeck/boring/archive/refs/tags/0.11.4.tar.gz"
  sha256 "a812f1475b5937d9b6d6b993fed34f3554a7ff9338ea6b6d21b19d4f9b5fc1e3"
  license "MIT"
  head "https://github.com/alebeck/boring.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebf05f99bd43f16fdd89a8884b3c6be5b3cd86097ea9a73f746221cd277043a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebf05f99bd43f16fdd89a8884b3c6be5b3cd86097ea9a73f746221cd277043a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ebf05f99bd43f16fdd89a8884b3c6be5b3cd86097ea9a73f746221cd277043a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "fed2db3cc5792d30011ed4e887869b275b0ee357dd88733601c4b407d8563ecd"
    sha256 cellar: :any_skip_relocation, ventura:       "fed2db3cc5792d30011ed4e887869b275b0ee357dd88733601c4b407d8563ecd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd80ecd0cc095245eadbfc52ecd8a2e8d30b71d970c4f4854feeb0405481a2c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebb99a37b8bded7f8667d915865cae568800494d8a6b15306ed3172f5872f16f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/boring"

    generate_completions_from_executable(bin/"boring", "--shell")
  end

  def post_install
    quiet_system "killall", "boring"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match version.to_s, shell_output("#{bin}/boring version")

    (testpath/".boring.toml").write <<~TOML
      [[tunnels]]
      name = "dev"
      local = "9000"
      remote = "localhost:9000"
      host = "dev-server"
    TOML

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"boring", "list", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "dev   9000   ->  localhost:9000  dev-server", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
