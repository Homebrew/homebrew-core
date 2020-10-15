class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.3.0",
      revision: "06a5dadcf259200cc08bb195e35488bb1e161930"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "3d044f1e0620b309d415c4743f44d44543f26ca472b88c9019f07db8f640830a" => :catalina
    sha256 "259e9332a58594c3facd9b50132d8e1e2cb5722eba693baf447f296bd6017671" => :mojave
    sha256 "d1d3f83fad8e8bc815a5494fa177a32c86edfa4f2202b8058b43c53205c191d9" => :high_sierra
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
