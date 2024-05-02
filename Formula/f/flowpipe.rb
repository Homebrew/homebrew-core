class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https://flowpipe.io"
  url "https://github.com/turbot/flowpipe/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "d5ff536f6f897a03f62f116c6ab00024415c6c8324e83d8f3567426b7bce83d3"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0281c0c2e5832fb2c14a576f9501bf79f91b939286b5e1fcf8b4f18b54e8dfa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "454c2b2149a06132d6abab02301e5a3aa622327236be11fb9b5c3f18c77f693f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f38186f6626f9e7e9bbb5a1f4db933b83c1ba486d800892617442ef0f19a317c"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b2fbd3aa7b33661969971809f12698382a0daf933fd6d754d2684285a7faeed"
    sha256 cellar: :any_skip_relocation, ventura:        "47c428ed06cb077fe24283bf91aad8b322debacfa60b6f8de5dd2e706b4d28eb"
    sha256 cellar: :any_skip_relocation, monterey:       "9640c9824a3f4071b510ed60a9d44234242b2dda57654af5f5e19a3526c2986b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc8831a4f2a02691948264cd350ff9daf438efd3fbed0797edb73d3b41b29fa7"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    cd "ui/form" do
      system "yarn", "install"
      system "yarn", "build"
    end

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X version.buildTime=#{time.iso8601}
      -X version.commit=#{tap.user}
      -X version.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowpipe -v")

    output = shell_output(bin/"flowpipe mod list 2>&1")
    if OS.mac?
      assert_match "Error: could not create sample workspace", output
    else
      assert_match "No mods installed.", output
    end
  end
end
