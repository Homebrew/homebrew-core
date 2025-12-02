class Portal < Formula
  desc "Quick and easy command-line file transfer utility from any computer to another"
  homepage "https://github.com/SpatiumPortae/portal"
  url "https://github.com/SpatiumPortae/portal/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "7a457ab1efa559b89eb5d7edbebccb1342896a42e30dbd943ffb6eea14179b36"
  license "MIT"
  head "https://github.com/SpatiumPortae/portal.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1eb19a1a5286dff89e6c783dfb092baa8b5fc2e6a859c4fa19c748918b00299e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c0f1d260c58e98e4fd7899ef87280ffe8efcc67d77764203a9d54fe35e47ab4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c0f1d260c58e98e4fd7899ef87280ffe8efcc67d77764203a9d54fe35e47ab4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c0f1d260c58e98e4fd7899ef87280ffe8efcc67d77764203a9d54fe35e47ab4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b091e6d917f3c32d54ae00142dbecf84c98b74985626b43df1dc4ea4c4bcf54c"
    sha256 cellar: :any_skip_relocation, ventura:       "b091e6d917f3c32d54ae00142dbecf84c98b74985626b43df1dc4ea4c4bcf54c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7eaec7e69e6599f5618d67f3f1869d24ab28c7032f6817b0f9945cb9ca06d504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4416bc3aa73043e6120fd97676142abae1de1f131454036ff9baecf61253068d"
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

    assert_path_exists test_file_receiver
    assert_equal test_file_receiver.read, test_file_content
  end
end
