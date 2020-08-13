class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.2.0",
      revision: "f7bef3cc404c57ccac95a5d0c6f07dfde88b13c6"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c8b2341f80eb3a9c66e84cfa74892e489627663d63cb79db2a147aeac8e6718" => :catalina
    sha256 "9c5ec77dff83e767202cd587f985d62f1562242e62b26ce6e6db6625e0d57b3d" => :mojave
    sha256 "c4d1b6f7ef9560bca26cf6880f9cc531bbe4188994cd82716ea8b74431d7fd32" => :high_sierra
  end

  depends_on "go" => :build

  def install
    commit = Utils.safe_popen_read("git", "rev-parse", "--short", "HEAD").chomp

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
