class Portal < Formula
  desc "Quick and easy command-line file transfer utility from any computer to another"
  homepage "https://github.com/SpatiumPortae/portal"
  url "https://github.com/SpatiumPortae/portal/archive/v1.2.3.tar.gz"
  sha256 "6d71f8c4b60da2bff404509fbeff57fc41a1300b51867aeace9632562fa9e30a"
  license "MIT"
  head "https://github.com/SpatiumPortae/portal.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "956d12c9e7f7c8f8979c8b17ca0eaeb45e8639419a8c8ab2d271ebf19e1def0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "956d12c9e7f7c8f8979c8b17ca0eaeb45e8639419a8c8ab2d271ebf19e1def0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "956d12c9e7f7c8f8979c8b17ca0eaeb45e8639419a8c8ab2d271ebf19e1def0c"
    sha256 cellar: :any_skip_relocation, ventura:        "93a8ee8abb4795f58ed78bf8050d87c68c997d6af40c9791e504cb93de26022a"
    sha256 cellar: :any_skip_relocation, monterey:       "93a8ee8abb4795f58ed78bf8050d87c68c997d6af40c9791e504cb93de26022a"
    sha256 cellar: :any_skip_relocation, big_sur:        "93a8ee8abb4795f58ed78bf8050d87c68c997d6af40c9791e504cb93de26022a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "611aa11a9045911553b7751fc59df6f0c58bbe9107d0b88442ee2d349da8d8e6"
  end

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
