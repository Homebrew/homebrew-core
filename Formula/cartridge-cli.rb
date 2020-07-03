class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      :tag      => "2.0.0",
      :revision => "e2eee9ca930f9d7b59e7f1402c90c709fc5a80f0"

  bottle do
    cellar :any_skip_relocation
    sha256 "fee467581eac3a74c6b461a245fd921f8b480a29e305ea871534d3ce2b111b86" => :catalina
    sha256 "320cab5411f776d343e52ba12ba54ae2d2c3c5cd2edf8b9fc61f9a5d278635d1" => :mojave
    sha256 "aa3c092706d946ef57398f876181b8840441f953232af2778eb3857f5e08345b" => :high_sierra
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
