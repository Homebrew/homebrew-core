class Boring < Formula
  desc "Simple command-line SSH tunnel manager that just works"
  homepage "https://github.com/alebeck/boring"
  url "https://github.com/alebeck/boring/archive/refs/tags/0.11.2.tar.gz"
  sha256 "d583878608549fcefa4fbe469d37a2e839c4d69a4167bc6a1a8babb31d594c98"
  license "MIT"
  head "https://github.com/alebeck/boring.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c5129cfdcd553feb66d99dea071355a2da7780b791484138fd6266941456046"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c5129cfdcd553feb66d99dea071355a2da7780b791484138fd6266941456046"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c5129cfdcd553feb66d99dea071355a2da7780b791484138fd6266941456046"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fc79b3983465481774760be3e7aaa4006ebdd67d953f41125b013eb51fcc0f6"
    sha256 cellar: :any_skip_relocation, ventura:       "1fc79b3983465481774760be3e7aaa4006ebdd67d953f41125b013eb51fcc0f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1b5bc0c35384e727d57d6c6e83e8ca1d77f8db478f4c33df5b009fa1a2d13d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09d6dc5f307e18e7947b4f72ede1744ae436f6aff9b4e38d5abf5a7198adb5c4"
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
