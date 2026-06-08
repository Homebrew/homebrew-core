class Boring < Formula
  desc "Simple command-line SSH tunnel manager that just works"
  homepage "https://github.com/alebeck/boring"
  url "https://github.com/alebeck/boring/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "13b5a6df9696f545dd4d2bd82a7d18e5ed80c5eaa5c2adb0373bc05ca0eb6bd0"
  license "MIT"
  head "https://github.com/alebeck/boring.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66247cee164ba7522f7ce1a578ca9009764a44690b944ee697483bfee9127f81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66247cee164ba7522f7ce1a578ca9009764a44690b944ee697483bfee9127f81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66247cee164ba7522f7ce1a578ca9009764a44690b944ee697483bfee9127f81"
    sha256 cellar: :any_skip_relocation, sonoma:        "22982707922325ae26fdbdbe5163a6ea3e6907de23d893f4a7a36c5fc2aaee17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb4248ca4eacaac0ecc400fca3fc47d24e12e13a8f7871a0c0e592f99384a094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0655261923746f8a5af097c979950f1853e92cd375b5c83e47e7264f2acb982b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/alebeck/boring/internal/buildinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/boring"

    generate_completions_from_executable(bin/"boring", "--shell")
  end

  def post_install
    quiet_system "killall", "boring"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/boring version")

    (testpath/(OS.linux? ? ".config/boring" : "")/".boring.toml").write <<~TOML
      [[tunnels]]
      name = "dev"
      local = "9000"
      remote = "localhost:9000"
      host = "dev-server"
    TOML

    assert_match "dev   9000   ->  localhost:9000  dev-server", shell_output("#{bin}/boring list")
  end
end
