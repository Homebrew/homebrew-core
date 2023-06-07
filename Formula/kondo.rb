class Kondo < Formula
  desc "Save disk space by cleaning non-essential files from software projects"
  homepage "https://github.com/tbillington/kondo"
  url "https://github.com/tbillington/kondo/archive/v0.6.tar.gz"
  sha256 "fce3082e294353e5a82ad1481796ea8130234eb581c31a279c9e7a73ca72d632"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8c2e9d4185083bdc761519d119c9a1d3d8d02fccdea0e417444699dbe028d65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8b12a287900b7a1fadb3072dd60796b5984795e346874ffe135090e2a35aa2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ce4e549ff1ce937ed56ca80ce6bef9a3d41602c94dd9f315fbe3c6034d6ad3a"
    sha256 cellar: :any_skip_relocation, ventura:        "b94a919725ee181014c822f681c4f389599fdc0585b4a921b6ea667340cf19ee"
    sha256 cellar: :any_skip_relocation, monterey:       "6dd70ff25fe27730675679c364fd094d3fa977701c9aa14488d10acbb7dd0f2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fa49fb3c41856bb09ec165932c770e0d040540c06ae556deeaf2a39c67c95bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2771396585ad4789c7daf2ed392ee8ac542bced3b23836ffb4a7865361d2f2f"
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
