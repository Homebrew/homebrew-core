class Docuum < Formula
  desc "Perform least recently used (LRU) eviction of Docker images"
  homepage "https://github.com/stepchowfun/docuum"
  url "https://github.com/stepchowfun/docuum/archive/v0.22.2.tar.gz"
  sha256 "34b4b945711a745d2cef9b82febc31b01ddd35182e4223f953b9e5947efc8a62"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c712fc4e7aaf499c0b0f5ebf6dfa39268d37a3f705093492d788daad5be8fa6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dd546c9f75279497a656c41af0d1ef006852264d618532d112ef84992c6bcbf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5332ff2e64224c473bd2cfc29a85cb63d00473e07ec02384360ab36c63480547"
    sha256 cellar: :any_skip_relocation, ventura:        "7568615f3ed3c05446d872443e4e30efb8dcbf185b8499e36e72427864203dd5"
    sha256 cellar: :any_skip_relocation, monterey:       "6633c191cd6fedcd4c6844f2f67a1bf2a98c5c5634b07f5fe8b22d0e05498fc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c2ec074b82a69e3ae46eb2cbdaccdb2ae0ad406c9d42d66c7edc54db21df28a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9e0efdbd6368e4b67acde1abd288d80e726c59d283f326a21573f40151888c0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  # https://github.com/stepchowfun/docuum#configuring-your-operating-system-to-run-the-binary-as-a-daemon
  service do
    run opt_bin/"docuum"
    keep_alive true
    log_path var/"log/docuum.log"
    error_log_path var/"log/docuum.log"
    environment_variables PATH: "#{std_service_path_env}:/usr/local/bin"
  end

  test do
    started_successfully = false

    Open3.popen3({ "NO_COLOR" => "true" }, "#{bin}/docuum") do |_, _, stderr, wait_thread|
      stderr.each_line do |line|
        if line.include?("Performing an initial vacuum on startup…")
          Process.kill("TERM", wait_thread.pid)
          started_successfully = true
        end
      end
    end

    assert(started_successfully, "Docuum did not start successfully.")
  end
end
