class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      :tag      => "2.1.0",
      :revision => "52f3f6837ea4896d9b476169813aa48de8e1e659"

  bottle do
    cellar :any_skip_relocation
    sha256 "512eddc42e90a1a83dd621937a88898586810276b1bdf6774a53b93e001b4591" => :catalina
    sha256 "5ea8de300c3f17ddfadcbc5c2d5d8b5b678067ce209094a9181e84366a0a4b2e" => :mojave
    sha256 "dd35ee608765bdb6bb5c29467058df59bd184927183ae9cac00c175e597be1e3" => :high_sierra
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
