class Kondo < Formula
  desc "Save disk space by cleaning non-essential files from software projects"
  homepage "https://github.com/tbillington/kondo"
  url "https://github.com/tbillington/kondo/archive/refs/tags/v0.8.tar.gz"
  sha256 "4054c90e679a379a735b3166df4633fb86a33725175ebe23d7b659dcb7155b26"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "20437a4779ae4204c41b3a47aea8330b4935b19045459dfc6287db2d56918389"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7f7ed792db60c8e6dab1cd65a717e23443a509f37fc9a5c3fc2c5b2be86fdf65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef1a8de9ec5ee7d8099bee48808e2472f8f7c328771b356961d1e3d901e247ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bbcb5abe74d2fb632d317a608adde42f9bbf59bec13eb3895f19811d6169ff3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b919fa810c7d632db59ab6b58757794eefae749feb39707fe7051d6bd95922ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "b0410e25e8402df9f2eb72277ac60caa2c9ae253b78f24cfb2a4e95ef977c259"
    sha256 cellar: :any_skip_relocation, ventura:        "805778bce56c10cd81b39677875a74313f518f88afe139a809113ec63f761f58"
    sha256 cellar: :any_skip_relocation, monterey:       "d62701b1f0dc9b3fcf5c7b54fedf7d2a42fab755c26370ebc3be1426e7abb616"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "84b9186af58150de46e72013a47b54df1d190a2ffcaa3e37be7bce9bc038ec2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4127563df7eadb5c588ca4a1d32795acf107ebc693fe225cd5d7f201caba636"
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
