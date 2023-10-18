class Kondo < Formula
  desc "Save disk space by cleaning non-essential files from software projects"
  homepage "https://github.com/tbillington/kondo"
  url "https://github.com/tbillington/kondo/archive/v0.7.tar.gz"
  sha256 "b7535807ba98bde86adfb920ec439e98b7c652361feb6a224e55c88cda569ff2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d41a495ad286d1ca4f1eb1fdb609b450cada828fcafd8623f9f01de24b5047d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9439938c1cb77f935fc6a3b5d7d3051b82ec38fc2737704ccf47e51000af7686"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78352c3fb16ad778bdb068de56e8b387ae257f10c0bfe6358b0dc6ec34e60698"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3db02b272e0f8b3ba8f751b78ac1285436f0d7d522f376fb2e72c2935ad1b5e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "42dfcb123cf399552021685dfaf47d7ea137fc9c4850312e984f2f5d2e65dde8"
    sha256 cellar: :any_skip_relocation, ventura:        "47db94484a736b9152cebcb4e1e1da160e0870e5bc74ab1527ff5017ee7d75b0"
    sha256 cellar: :any_skip_relocation, monterey:       "87a591bd0f7fe7bba6892bbb61d02062ebff165a4a95e43ae7a16c790a2c8870"
    sha256 cellar: :any_skip_relocation, big_sur:        "e225f24a1593efa6ce3b705511e110f2bd0f603b44032d3d082490657ec7dc6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea1ef61bcedfd85543049016f4a582923b91c7c192a27efe55029f78c660dd45"
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
