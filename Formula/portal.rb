class Portal < Formula
  desc "Quick and easy command-line file transfer utility from any computer to another"
  homepage "https://github.com/SpatiumPortae/portal"
  url "https://github.com/SpatiumPortae/portal/archive/v1.2.3.tar.gz"
  sha256 "6d71f8c4b60da2bff404509fbeff57fc41a1300b51867aeace9632562fa9e30a"
  license "MIT"
  head "https://github.com/SpatiumPortae/portal.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb5d90d8201664c8eee810e7dbdcecdd25e7a9a88c19ce21b9d9b62c7ef5cff9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb5d90d8201664c8eee810e7dbdcecdd25e7a9a88c19ce21b9d9b62c7ef5cff9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb5d90d8201664c8eee810e7dbdcecdd25e7a9a88c19ce21b9d9b62c7ef5cff9"
    sha256 cellar: :any_skip_relocation, ventura:        "70be550a28d8e0fdbd8cd639e7fd909af78cb5d7a75b18be12992b91319f8f2b"
    sha256 cellar: :any_skip_relocation, monterey:       "70be550a28d8e0fdbd8cd639e7fd909af78cb5d7a75b18be12992b91319f8f2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "70be550a28d8e0fdbd8cd639e7fd909af78cb5d7a75b18be12992b91319f8f2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a518d52bedd55a0cb2612f851ec21f8670443300ef028f197fafa2d8369afd08"
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
