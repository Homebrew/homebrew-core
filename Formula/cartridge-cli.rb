class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.2.1",
      revision: "b1463509ed21c1ddc6a2e83287110e3631491761"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "20d72c607d26bc646a42257941cbb8651c3a3ac59917d185d1f6e76e1cb02662" => :catalina
    sha256 "fbdc048f572c59b6b1d3d57690cd53e1fd5391931a6519a090f9850870573f6f" => :mojave
    sha256 "449eea1518208b3f8adc8970240180c3303d3496d5e14fcc11417b8c3f422f06" => :high_sierra
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
