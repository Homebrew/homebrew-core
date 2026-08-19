class LocalsendCli < Formula
  desc "Open-source cross-platform alternative to AirDrop"
  homepage "https://localsend.org"
  url "https://github.com/localsend/localsend/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "b7bc1b01a4d65ff12fa1e13e6e22b7130fa3203bfcb46793e67afc0741d3d365"
  license "Apache-2.0"
  head "https://github.com/localsend/localsend.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    filename = "test.gif"
    original_file = test_fixtures(filename)

    ## Transfert file
    require "pty"

    # An identity file is created in the config folder preventing two instance
    # with the same config from sending file to each other
    receiver_config = testpath/"receiver"
    receiver_config.mkdir
    sender_config = testpath/"sender"
    sender_config.mkdir

    ENV["XDG_CONFIG_HOME"] = receiver_config.realpath
    _r, writer_receiver, pid_receiver = PTY.spawn(bin/"localsend-cli", "--port=#{free_port}", "--destination=.")

    ENV["XDG_CONFIG_HOME"] = sender_config.realpath
    _r, writer_sender, _pid_sender = PTY.spawn(bin/"localsend-cli", "--port=#{free_port}", "-f", original_file)

    sleep 10 # Time to find each other
    writer_sender.puts "\r\n" # Press Enter
    sleep 10 # Time to hear about file transfert
    writer_receiver.puts "Y" # Accept file transfert
    sleep 10 # Time to transfer

    ## Check successful transfert
    require "fileutils"

    assert compare_file(original_file, filename)

  # Cleanup
  ensure
    Process.kill("TERM", pid_receiver)
    Process.wait(pid_receiver)
  end
end
