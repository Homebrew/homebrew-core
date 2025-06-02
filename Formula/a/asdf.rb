class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://asdf-vm.com/"
  url "https://github.com/asdf-vm/asdf/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "47446cd6007b743ee207541fa8ebcddaae2c988f4cbd9dd845a2a7806d5d2f90"
  license "MIT"
  head "https://github.com/asdf-vm/asdf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fd57ba8ec2e1b39ed8d34efb08c794c7f0ea05e6e352e2ab7a8b974ee82b644"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fd57ba8ec2e1b39ed8d34efb08c794c7f0ea05e6e352e2ab7a8b974ee82b644"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1fd57ba8ec2e1b39ed8d34efb08c794c7f0ea05e6e352e2ab7a8b974ee82b644"
    sha256 cellar: :any_skip_relocation, sonoma:        "59d0ac671690b617c0711a827af5e8b09ca0a102ee1aac5452b80e865e8c679e"
    sha256 cellar: :any_skip_relocation, ventura:       "59d0ac671690b617c0711a827af5e8b09ca0a102ee1aac5452b80e865e8c679e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb61474dd1cdf6aa17db4b0c28ecf5e5e969634f26b8a9f91a3cb8fddc1ad1b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9661381baaa99124e46746a0181b5b808db58b66bb9d6c25be76f934f104b38b"
  end

  depends_on "go" => :build
  depends_on "git"

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
