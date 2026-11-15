class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://asdf-vm.com/"
  url "https://github.com/asdf-vm/asdf/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "29f5b702f532f345270e2f7bb8b01ea07dbc6892e34ec8c97a180002794684e3"
  license "MIT"
  head "https://github.com/asdf-vm/asdf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "11395793631019858ca30d90a18dc1a91d2d73312d01365488d03f8c3a641fbd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "11395793631019858ca30d90a18dc1a91d2d73312d01365488d03f8c3a641fbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "11395793631019858ca30d90a18dc1a91d2d73312d01365488d03f8c3a641fbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eb4859574064a3e8ba599b447ee8d96853b02c62f4692ffbf1a7398f6db5642d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "73c846eac2f880bd73f8675780a30ffd43ef151febc5a50333a3cd66760bfd9f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # fix https://github.com/asdf-vm/asdf/issues/1992
    # relates to https://github.com/Homebrew/homebrew-core/issues/163826
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/asdf"
    generate_completions_from_executable(bin/"asdf", "completion")
    libexec.install Dir["asdf.*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asdf version")
    assert_match "No plugins installed", shell_output("#{bin}/asdf plugin list 2>&1")
  end
end
