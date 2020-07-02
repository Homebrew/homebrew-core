class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      :tag      => "2.0.0",
      :revision => "e2eee9ca930f9d7b59e7f1402c90c709fc5a80f0"

  bottle do
    cellar :any_skip_relocation
    sha256 "97594ccc826825551bd5aa049c6bcf9cef6d0b1dd949e47d6320c27a4f595331" => :catalina
    sha256 "663503437606e491c490a42bd8360938bde5f09e8d9078203a42190dcac16214" => :mojave
    sha256 "6f579768ca73d8354418214ab79732a6b29a7f43dee8d3a4122bbab842906aeb" => :high_sierra
  end

  depends_on "go" => :build

  def install
    commit = Utils.safe_popen_read("git rev-parse --short HEAD").chomp

    ldflags = %W[
      -s -w
      -X github.com/tarantool/cartridge-cli/cli/version.gitTag=#{version}
      -X github.com/tarantool/cartridge-cli/cli/version.gitCommit=#{commit}
    ]

    system "go", "build", "-o", bin/"cartridge", "-ldflags", ldflags.join(" "), "cli/main.go"
  end

  test do
    project_path = Pathname("test-project")
    project_path.rmtree if project_path.exist?
    system bin/"cartridge", "create", "--name", project_path
    assert_predicate project_path, :exist?
    assert_predicate project_path.join("init.lua"), :exist?
  end
end
