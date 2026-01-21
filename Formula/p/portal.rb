class Portal < Formula
  desc "Quick and easy command-line file transfer utility from any computer to another"
  homepage "https://github.com/SpatiumPortae/portal"
  url "https://github.com/SpatiumPortae/portal/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "7a457ab1efa559b89eb5d7edbebccb1342896a42e30dbd943ffb6eea14179b36"
  license "MIT"
  head "https://github.com/SpatiumPortae/portal.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a0fececdc0986916ca99288467480b34e73c7340a73dbf2a6686aa15f2c1e09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a0fececdc0986916ca99288467480b34e73c7340a73dbf2a6686aa15f2c1e09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a0fececdc0986916ca99288467480b34e73c7340a73dbf2a6686aa15f2c1e09"
    sha256 cellar: :any_skip_relocation, sonoma:        "6be6e1884a5456ed3f4b00af608eb1f7fe3ae61c24955e849be533e160f8f2d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "618c8281bf6be5da1a11265d37c59366cf95968f5be4cb83cc1a04bbcb06c038"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c25fecd8c524f41b67e339aeca037e7782f157384c99ec550ccfe3d627f012ef"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/portal/"

    generate_completions_from_executable(bin/"portal", shell_parameter_format: :cobra)
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

    assert_path_exists test_file_receiver
    assert_equal test_file_receiver.read, test_file_content
  end
end
