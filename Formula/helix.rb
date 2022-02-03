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
    require "pty"
    require "io/console"

    test_file = testpath/"test.txt"

    r, w, pid = PTY.spawn bin/"hx", test_file
    r.winsize = [80, 43]
    sleep 1
    w.write "itest\e"
    sleep 1
    w.write ":wq\n"
    sleep 1
    Process.wait(pid)
    assert_equal "test", test_file.read.chomp
  end
end
