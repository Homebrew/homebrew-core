class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://asdf-vm.com/"
  url "https://github.com/asdf-vm/asdf/archive/refs/tags/v0.16.4.tar.gz"
  sha256 "6b63b7b5edc37fb8af9d676a0f7bf2cc3cf449045eef8f9d1bf45b99b42842ee"
  license "MIT"
  head "https://github.com/asdf-vm/asdf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ccae5c4cdbbea464bcdb967d2aa594c784512401f3fa2bdf121b6b397699215"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ccae5c4cdbbea464bcdb967d2aa594c784512401f3fa2bdf121b6b397699215"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ccae5c4cdbbea464bcdb967d2aa594c784512401f3fa2bdf121b6b397699215"
    sha256 cellar: :any_skip_relocation, sonoma:        "c97d96964302047dd0372fb9707f5b121b1f63749d91326937345a4a39e4796a"
    sha256 cellar: :any_skip_relocation, ventura:       "c97d96964302047dd0372fb9707f5b121b1f63749d91326937345a4a39e4796a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f861eb34da725ab46d0aead2f7efc1a76dba28fd5ba8b3101883bbb519a87def"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/asdf"
    generate_completions_from_executable(bin/"asdf", "completion")
    libexec.install Dir["asdf.*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asdf version")
    assert_match "No plugins installed", shell_output("#{bin}/asdf plugin list 2>&1")
  end
end
