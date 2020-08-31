class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.3.0",
      revision: "06a5dadcf259200cc08bb195e35488bb1e161930"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "08645b29f4bf81b24d4aa17e98707ee21556e687dfe8496410a6ee6a57e1eaea" => :catalina
    sha256 "1d14735ddd85b022fb414eabfc5cfc5fa140538c6d525113758d844604b54a81" => :mojave
    sha256 "016c1858d75fb0534100ce7135348b5c71458e46049af35e2ed0adb73bc661cb" => :high_sierra
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
