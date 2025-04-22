class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://asdf-vm.com/"
  url "https://github.com/asdf-vm/asdf/archive/refs/tags/v0.16.7.tar.gz"
  sha256 "095b95ec198b53a5240b41475e7dc423a055e57ee3490e325b8af11f22f03bd8"
  license "MIT"
  head "https://github.com/asdf-vm/asdf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b11cb41bc93a3cebef6569e49be6f5d0e10ab5ec73a9d2ace497051be47d86f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b11cb41bc93a3cebef6569e49be6f5d0e10ab5ec73a9d2ace497051be47d86f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b11cb41bc93a3cebef6569e49be6f5d0e10ab5ec73a9d2ace497051be47d86f"
    sha256 cellar: :any_skip_relocation, sonoma:        "adbd7a982debcdc997738056fdcc6660e374b827f5343de7718a71dd23328426"
    sha256 cellar: :any_skip_relocation, ventura:       "adbd7a982debcdc997738056fdcc6660e374b827f5343de7718a71dd23328426"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "556fbd603b7a063de705436994807f5312f507b25df48db43245c3c4351081f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8faea147297d8c56864d414580966e398edf447b47a21d125c7accddb886fed"
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
