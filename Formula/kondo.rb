class Kondo < Formula
  desc "Save disk space by cleaning non-essential files from software projects"
  homepage "https://github.com/tbillington/kondo"
  url "https://github.com/tbillington/kondo/archive/v0.5.tar.gz"
  sha256 "d26646e1d098909b61f982945484883fb82f08df48ac8b2a9cc9bed8a45ff5cf"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb5b73c4302c104b177064b47eeacd6f8b6e480bdc728d50bb2e249c1fb5704f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "083e5733e8bf0483348cd113f467de63e5b726bb503abc5311dd9b1a8ead9ed1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d031899ed01d3ab445a349fc575ea7b79e5ebdf2c3826968c849d1a4973c979"
    sha256 cellar: :any_skip_relocation, monterey:       "2d223967e5935a86b2ed54e6bf0f440833ab4eaf5226a4fb54cd92068a9a9526"
    sha256 cellar: :any_skip_relocation, big_sur:        "60c02e25eb4f689ea69a97a56a17f76b004b777337fa19a40a58c5d5009cfd74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75a47669cba55361a9c4525833da264c073bd847e0cf61fb5bff409a5a2c9327"
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
