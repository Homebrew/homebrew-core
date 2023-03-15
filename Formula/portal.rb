class Portal < Formula
  desc "Quick and easy command-line file transfer utility from any computer to another"
  homepage "https://github.com/SpatiumPortae/portal"
  url "https://github.com/SpatiumPortae/portal/archive/v1.2.2.tar.gz"
  sha256 "94c334285925175edfc470239ea2cc73a0039f9487ce92e60764f0965aba66d4"
  license "MIT"
  head "https://github.com/SpatiumPortae/portal.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/portal/"
  end

  test do
    # Simple version check test.
    assert_match version.to_s, shell_output("#{bin}/portal version")

    # Start a local relay server on an open port.
    port=free_port
    fork do
      exec "#{bin}/portal", "serve", "--port=#{port}"
    end
    sleep 2

    test_file_name="test.txt"
    test_file_content="sup, world"

    # Send a testing text file through the local relay (raw flag to easily extract the password).
    # Write the password to "password.txt" in the testpath.
    test_file_sender=(testpath/"sender"/test_file_name)
    test_file_sender.write(test_file_content)
    password_file=(testpath/"password.txt")
    fork do
      $stdout.reopen(password_file)
      exec "#{bin}/portal", "send", "-s=raw", "--relay=:#{port}", test_file_sender
    end
    sleep 2

    # Receive the text file through the local relay.
    receiver_path=(testpath/"receiver")
    fork do
      mkdir_p receiver_path
      cd receiver_path do
        exec "#{bin}/portal", "receive", "-s=raw", "-y", "--relay=:#{port}", password_file.read.strip
      end
    end
    sleep 2

    test_file_receiver=(receiver_path/test_file_name)

    assert_predicate test_file_receiver, :exist?
    assert_equal test_file_receiver.read, test_file_content
  end
end
