class Kondo < Formula
  desc "Save disk space by cleaning non-essential files from software projects"
  homepage "https://github.com/tbillington/kondo"
  url "https://github.com/tbillington/kondo/archive/v0.4.tar.gz"
  sha256 "f5044d744e3eb0db815c521537a34cfbead18bd7d5df0f6f5312a8c4f72f682e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51fc93b291759d478b8120e55dfede120f442b8c453d9b1c8e1021631a2b7921"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6fe4c87eeb87a4a2c4d9a642a6b5f5df8ebea6acf6a8df7d5deeb536c1be2f9"
    sha256 cellar: :any_skip_relocation, monterey:       "cad70450fe1b6c5fe6938877409fca4ed0eadf6b5328572a5379a3b012d062c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "fbee7326b1a3528129a6b900b1582c2e7573e631ff0fc7497f967ec4ccd92481"
    sha256 cellar: :any_skip_relocation, catalina:       "3bf874b00e0c442d3887e076389c3bca0d1f1d2830713d179d8377ae2a5eb5cb"
    sha256 cellar: :any_skip_relocation, mojave:         "f4cb386aa743645639124f47729afcb5b9a545a97eb3ab6785aa0dfbc432a18f"
    sha256 cellar: :any_skip_relocation, high_sierra:    "1636cef203700859a8bcf48b315325192fe6a3fa0a0fa05df89e23e28833f161"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd82521d1ee2a91aa7d388b4659dbef3023ed22690a914cf47b4dfdfcaab54c0"
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
