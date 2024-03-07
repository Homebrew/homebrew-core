class Portal < Formula
  desc "Quick and easy command-line file transfer utility from any computer to another"
  homepage "https://github.com/SpatiumPortae/portal"
  url "https://github.com/SpatiumPortae/portal/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "7a457ab1efa559b89eb5d7edbebccb1342896a42e30dbd943ffb6eea14179b36"
  license "MIT"
  head "https://github.com/SpatiumPortae/portal.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e333a3b75d4b33b387c0bb6749b01e44992c5c886331f91d948dc4f59dc7b1f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5582fc03d1182135f8c7e73cb4503a8cedcd5350264185551f07ce37e09986d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f858964534d5af5cef3195b4ad2fa818f07bf79deeea55f328b9db9d04c5616a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98ad1510eb543d4c3129e6d17c1a844f99cb039615a1a281489bd4c4bb2485ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "71a2ce1ca0a91067eed10793f2981eafb0cde923f68b27e975341d87b1ec58b0"
    sha256 cellar: :any_skip_relocation, ventura:        "885a629b00af358c5d919abede7ea6b7be6604b2805279e0a5d9d9d435633101"
    sha256 cellar: :any_skip_relocation, monterey:       "ed4cde3174861f1109761cf4934093fe18330a2b60a4266b0efb692b4d390214"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ff2035231f98a1cc9c4e5c945619feb5336b9bf8b4736e8245be36cceb41270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db75b7a2beec3a4b2920bc8b44c6045206930a73d08cbccf481a98b176de56d7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/portal/"
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
