class Helix < Formula
  desc "Post-modern modal text editor"
  homepage "https://helix-editor.com"
  url "https://github.com/helix-editor/helix.git",
       tag:      "v0.6.0",
       revision: "ac1b7d8d0a608f47edfee2872d414e94fd26cc31"
  license "MPL-2.0"
  head "https://github.com/helix-editor/helix.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "helix-term")
    libexec.install "runtime"
    bin.env_script_all_files libexec/"bin", HELIX_RUNTIME: libexec/"runtime"
  end

  test do
    require "open3"
    Open3.popen3("#{bin}/hx") do |stdin, _stdout, stderr, wait_thr|
      on_macos do
        error_msg = "Piping into helix-term is currently not supported on macOS"
        assert_match error_msg, stderr.read
        assert_equal 1, wait_thr.value.exitstatus
      end
      on_linux do
        stdin.write "test"
        sleep 5.seconds
        system "kill", "-SIGTERM", wait_thr.pid.to_s
      end
    end
  end
end
