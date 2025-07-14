class BazelRemote < Formula
  desc "Remote cache for Bazel"
  homepage "https://github.com/buchgr/bazel-remote/"
  url "https://github.com/buchgr/bazel-remote/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "ec2d5fa65fa15e571347627cbd0a104a95ff66479e694e534257e703fa580d66"
  license "Apache-2.0"
  head "https://github.com/buchgr/bazel-remote.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e42f5b3e1d951c49b40b8b60ce2df83ce1cf6a21e8ecfecf8cc5e2cfd7d087a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2d903c8c87c763476299b3b39404ef6781a1749a0ab7296d691f675f36a986b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "836a4e71d3cdd9d82b331f60f77fc8ef7b6a12f45a2c3056395f62b9399c0adc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6685a17ca98be8653c9f5e4e8f6bc4c9d606d10eee3b827c8dbc7db3cdddf9f"
    sha256 cellar: :any_skip_relocation, ventura:       "f5b02293e474d05f3734c188edb9fa925d01f91baff1c4f006717d595e1235fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "049efc5f440e85bdc3c985d7b4cf341b75a047a9555f8696dd8d75f49ea472ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c31a68807911ee688a0648a85652831d2d77bde81b806e2ebec9d5fd452c7890"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.gitCommit=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["BAZEL_REMOTE_DIR"] = "test"
    ENV["BAZEL_REMOTE_MAX_SIZE"] = "10"

    begin
      pid = fork { exec bin/"bazel-remote" }
      sleep 2
      assert_path_exists testpath/"test", "Failed to create test directory"
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
