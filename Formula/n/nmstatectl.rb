class Nmstatectl < Formula
  desc "Command-line tool that manages host networking settings in a declarative manner"
  homepage "https://nmstate.io/"
  url "https://github.com/nmstate/nmstate/releases/download/v2.2.57/nmstate-2.2.57.tar.gz"
  sha256 "7bbc0543349b7feec33b30476901ae90b192a1a361ff6fc2f66e22bf2dc082ec"
  license "Apache-2.0"
  head "https://github.com/nmstate/nmstate.git", branch: "base"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3035a3433ab435294d0869a65936beae2c1e544b39d070bfb66137b443024576"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b5f44465635841531c7fe43d453d5da280573788ad01acf5a3896f7e03a7c74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd06f57c4aa0df4027d3b0e2a1dc18856186e0ed9865aec4b92dbac52e52a65b"
    sha256 cellar: :any_skip_relocation, sonoma:        "70841b5dc2a5aa9ddcde8f53dc6fd29e8c970b69294ccb19a07840c335dc8762"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "225dca77c67ca7aa077c9f34ecac978c09e3ea64aa55ac000e61da5db35db1fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "907c0675af9593c5e545b65bed2e22cb988daed720d18a168fc0e8b5464e7081"
  end

  depends_on "rust" => :build

  def install
    cd "rust" do
      args = if OS.mac?
        ["--no-default-features", "--features", "gen_conf"]
      else
        []
      end
      system "cargo", "install", *args, *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nmstatectl --version")

    assert_match "interfaces: []", pipe_output("#{bin}/nmstatectl format", "{}", 0)
  end
end
