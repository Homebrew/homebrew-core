class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.5.0",
      revision: "98f361c2a44bc003ff2838fc9b20bd5fa2b4a876"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "36b4a24aa4eee700efcfec46107c82ed174323aa7f83f376fe06a593f47c0e69" => :big_sur
    sha256 "e2c87063b2481f05b18b4fdfe021faa5e1d1eb316cf54bd52f5a4629af92d944" => :catalina
    sha256 "6bf464938f916b536ffa8a8ca432a9fe6873361acaeebdcd123431c5fc6698b2" => :mojave
    sha256 "840ed4a029be0ff0e398072dfedefbbc93130f4ceca41c79d9adea068a367b2f" => :high_sierra
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
    system bin/"cartridge", "gen", "completion"

    bash_completion.install "completion/bash/cartridge"
    zsh_completion.install "completion/zsh/_cartridge"
  end

  test do
    project_path = Pathname("test-project")
    project_path.rmtree if project_path.exist?
    system bin/"cartridge", "create", "--name", project_path
    assert_predicate project_path, :exist?
    assert_predicate project_path.join("init.lua"), :exist?
  end
end
