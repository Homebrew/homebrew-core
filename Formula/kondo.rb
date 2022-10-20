class Kondo < Formula
  desc "Save disk space by cleaning non-essential files from software projects"
  homepage "https://github.com/tbillington/kondo"
  url "https://github.com/tbillington/kondo/archive/v0.5.tar.gz"
  sha256 "d26646e1d098909b61f982945484883fb82f08df48ac8b2a9cc9bed8a45ff5cf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d3f4ffcd0ca6b35d9002a4a150376920f1ec3bd18c6e21ecddee77a7d63c2f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83725018560e700eddc7e976c35403901cf89298679459c451c1905c55c38173"
    sha256 cellar: :any_skip_relocation, monterey:       "52407e9d2c5170245ecdd01de9b6ed5024fb22659ef0c680a509232937f62f73"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ddadc0aee89c286f2d2eb436746912762fee3a0f24e4d83c6adc5f7549e2c76"
    sha256 cellar: :any_skip_relocation, catalina:       "22ba00f9ceac0581035ab211ccbf1d235a615a46793f0a855e35d7b868c4e6a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cae0a0fb7b49ba6d1927fe1b3f524ac509bdc7b70af72b6cf6249c6dd02a652"
  end

  depends_on "rust" => :build

  def install
    # The kondo command line program in in the kondo subfolder, so we navigate there.
    cd "kondo" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    require "open3"

    # Write a Cargo.toml file so kondo will interpret this directory as a Cargo project.
    (testpath/"Cargo.toml").write("")

    # Create a dummy file which we will delete via kondo.
    dummy_artifact_path = (testpath/"target/foo")

    # Write 10 bytes into the dummy file.
    dummy_artifact_path.write("0123456789")

    # Run kondo. It should detect the Cargo.toml file and interpret the directory as a Cargo project.
    # The output should look roughly like the following:
    #
    # /private/tmp/kondo-test-20200731-55654-i9otaa Cargo project
    #     target (10.0B)
    #   delete above artifact directories? ([y]es, [n]o, [a]ll, [q]uit):
    #
    # We're going to simulate a user pressing "n" for no.
    # The result of this should be that the dummy file still exists after kondo has exited.
    Open3.popen3(bin/"kondo") do |stdin, _stdout, _, wait_thr|
      # Simulate a user pressing "n" then pressing return/enter.
      stdin.write("n\n")

      # Wait for the kondo process to exit.
      wait_thr.value

      # Check that the dummy file still exists.
      assert_equal true, dummy_artifact_path.exist?
    end

    # The concept is the same as the above test, except this time we will simulate pressing "y" for yes.
    # The result of this should be that the dummy file still no longer exists after kondo has exited.
    Open3.popen3(bin/"kondo") do |stdin, _stdout, _, wait_thr|
      # Simulate a user pressing "y" then pressing return/enter.
      stdin.write("y\n")

      # Wait for the kondo process to exit.
      wait_thr.value

      # Check that the dummy file no longer exists.
      assert_equal false, dummy_artifact_path.exist?
    end
  end
end
