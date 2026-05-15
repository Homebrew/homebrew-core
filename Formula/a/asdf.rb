class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://asdf-vm.com/"
  url "https://github.com/asdf-vm/asdf/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "bd2b497b0c58017cb7c863550d9cf585aefbd74e334a567cd6b8dcb339bb1806"
  license "MIT"
  head "https://github.com/asdf-vm/asdf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b4f7836d3f8dd1b4b8958612843c0265cec41dd54c61e4e72ddbb7e2f58bf49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b4f7836d3f8dd1b4b8958612843c0265cec41dd54c61e4e72ddbb7e2f58bf49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b4f7836d3f8dd1b4b8958612843c0265cec41dd54c61e4e72ddbb7e2f58bf49"
    sha256 cellar: :any_skip_relocation, sonoma:        "d41db2d847be8153637321d3b02f09c683c41f676be9fde04c0b8fe382829055"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "607bac77c488c042954081712d7be3ec8640cd2f6c0e5a241aabd65611f8612c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20cda6dddd47e19cf89cb107253e3e716333443d885bde1c82ddd0a41c53a620"
  end

  depends_on "go" => :build

  def install
    # fix https://github.com/asdf-vm/asdf/issues/1992
    # relates to https://github.com/Homebrew/homebrew-core/issues/163826
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/asdf"
    generate_completions_from_executable(bin/"asdf", "completion")
    libexec.install Dir["asdf.*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asdf version")
    assert_match "No plugins installed", shell_output("#{bin}/asdf plugin list 2>&1")
  end
end
