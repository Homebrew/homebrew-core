class Kondo < Formula
  desc "Save disk space by cleaning non-essential files from software projects"
  homepage "https://github.com/tbillington/kondo"
  url "https://github.com/tbillington/kondo/archive/refs/tags/v0.9.tar.gz"
  sha256 "188c577f1d21d783cd2b4b43a5cbae5ffe8b085e5773e10846af55968ddd50c4"
  license "MIT"
  head "https://github.com/tbillington/kondo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "527d27a29a5f7b9bb39be35e8054c34c0c4f617a1502feea1afa4943cd815bd2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69cb21681a558ebb79ae06bddba9548d0104060a7425711f6eda260170f0c412"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9dab17a98c8e5da226da1d7e4a94e69d23fc4d9013b5a198d260e035ef60daa"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b154e3bbf7f2da0097a366443e41797203d706a05fb5db257ddab1481d8fccf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4521a5aaaa9683347a699c7a85bb89d42e448431d45b99645a9f0116fe19c40e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d282eae511caf3bc620fbe9bd92abcf629febe09ba711fca0e0e63e8169eb9e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "kondo")
    generate_completions_from_executable(bin/"kondo", "--completions")
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
