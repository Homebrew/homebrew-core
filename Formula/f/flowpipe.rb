class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https://flowpipe.io"
  url "https://github.com/turbot/flowpipe/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "758f64b8853c91aa7ea8981df847855996cf29a8655f9a8bc1552e73a7ca1ad6"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31e45e369a65f7832bd1fb03ac4582156f2f56c1d465a4f2e50740ead9a25294"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5123c099e40c6334d8db26582ba4ce2bfecc6703d546c8c936b9a806765a045"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "831a5d1e3e4b53ee915c571941e3e856b86cf9b48078de4dd7579ce7cc2ab3c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "c30a344e3ef5bfcf77a0fb75abcc9a5df115f8d0b8cb75a26b961a9777d034b2"
    sha256 cellar: :any_skip_relocation, ventura:        "04b5b710279ef62eb5bebcd679b84c04045c6789eb27bbafedbad7a7359b9c66"
    sha256 cellar: :any_skip_relocation, monterey:       "7744312e46271161d2f2e04b91d1091866a8dc5c7f3f3875eaad4e054c152fe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02e43e19d37dd93b31c730f4b6011391f1dc0b43055723e08942b820ad0ac794"
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
