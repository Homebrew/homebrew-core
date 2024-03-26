class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https://flowpipe.io"
  url "https://github.com/turbot/flowpipe/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "55fdfa27f99b8430d0d0b119842df2eb85b409ec7e44119f08a084d527adeba3"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "028c494f378c3d59c7230117776b9455212399b11a9a319699efa38b2b487150"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63410a4de916feeeec077072508b85ea08167cd69fc34cd3381de4f0e175c70e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a7bdef3f3fb0a58a278a1e5a58c47e603830c54a681cb1976e70c5acfc99f4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "74d0544afbec5a47c50ad7e910e7bb287604208024549e13726ed683fe5f17c2"
    sha256 cellar: :any_skip_relocation, ventura:        "2f601d1747831da7a68fd1971b9d0885a09fb77ed8ddedbde4a0dc28778e1eac"
    sha256 cellar: :any_skip_relocation, monterey:       "1d47ff2cf57a38140cb6c443b48e17d2fc05a5fe601e82fcbe63114e2e50771a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e7fcd5c42cd71219037bc0d1fbd1773eba877bd774640cf87fb8dbc3a77338c"
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
