class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://asdf-vm.com/"
  url "https://github.com/asdf-vm/asdf/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "3dbde020f345d397f4cf1eb1fceabba552ea3aaf83108785b1a9e9a1d6430f18"
  license "MIT"
  head "https://github.com/asdf-vm/asdf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2755a56914e02b70ecb080a9c7923252eb556d0f4e1831054217cd9c280144e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2755a56914e02b70ecb080a9c7923252eb556d0f4e1831054217cd9c280144e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2755a56914e02b70ecb080a9c7923252eb556d0f4e1831054217cd9c280144e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "361fc9c9cd741886725d249116b97e54b5179afa8bfad181f2dd6de43c62498b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d4bf5331ed531f43d7a0e5293138c50e2f8115cb80ca44194edab4d30a697f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed50651cba368e74c59aa7e99205831c0002e976dc7cfb1fb88c8ba47dcaf359"
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
