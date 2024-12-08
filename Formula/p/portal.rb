class Portal < Formula
  desc "Quick and easy command-line file transfer utility from any computer to another"
  homepage "https://github.com/SpatiumPortae/portal"
  url "https://github.com/SpatiumPortae/portal/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "7a457ab1efa559b89eb5d7edbebccb1342896a42e30dbd943ffb6eea14179b36"
  license "MIT"
  head "https://github.com/SpatiumPortae/portal.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dd7ebc23dfcc62dd51a4cc2dfb3f1d3b56812e5937edc17b52877e49715705a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dd7ebc23dfcc62dd51a4cc2dfb3f1d3b56812e5937edc17b52877e49715705a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1dd7ebc23dfcc62dd51a4cc2dfb3f1d3b56812e5937edc17b52877e49715705a"
    sha256 cellar: :any_skip_relocation, sonoma:        "07a49d8e455386ed83187e1d74641b1ed0bf0096c008e989e35e6f3342f3f7f0"
    sha256 cellar: :any_skip_relocation, ventura:       "07a49d8e455386ed83187e1d74641b1ed0bf0096c008e989e35e6f3342f3f7f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53b9ee9ad5b6d0fe63eb4f44a9860c790e1859038b8e6ee9a91f7a550caa73ff"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/portal/"

    generate_completions_from_executable(bin/"portal", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/portal version")

    # Start a local relay server on an open port.
    port=free_port
    fork do
      exec bin/"portal", "serve", "--port=#{port}"
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
      exec bin/"portal", "send", "-s=raw", "--relay=:#{port}", test_file_sender
    end
    sleep 2

    # Receive the text file through the local relay.
    receiver_path=(testpath/"receiver")
    fork do
      mkdir_p receiver_path
      cd receiver_path do
        exec bin/"portal", "receive", "-s=raw", "-y", "--relay=:#{port}", password_file.read.strip
      end
    end
    sleep 2

    test_file_receiver=(receiver_path/test_file_name)

    assert_predicate test_file_receiver, :exist?
    assert_equal test_file_receiver.read, test_file_content
  end
end
