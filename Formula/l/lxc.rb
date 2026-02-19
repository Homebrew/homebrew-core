class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://ubuntu.com/lxd"
  url "https://github.com/canonical/lxd/releases/download/lxd-6.6/lxd-6.6.tar.gz"
  sha256 "2ddfa88441ef1f4f1f0b49cce11285620e34f3245e792f22034a688f3c07233a"
  license "AGPL-3.0-only"
  head "https://github.com/canonical/lxd.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3432a8b0883d111ffdf8aa0549931386690f1946478d29fadbe39dfed90c6689"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3432a8b0883d111ffdf8aa0549931386690f1946478d29fadbe39dfed90c6689"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3432a8b0883d111ffdf8aa0549931386690f1946478d29fadbe39dfed90c6689"
    sha256 cellar: :any_skip_relocation, sonoma:        "5170557cd4a48cb11314489480b3dde4a5781626782326cb23657203ea5811ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "976e58e0fcbda92ec01d53cc8c1d25168169534a6531529747ba3c97fd4dcad6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a897ae79d2929a54f9b4a6042900e2e9a01f36c55400c05440b2200c68b135f4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./lxc"

    generate_completions_from_executable(bin/"lxc", shell_parameter_format: :cobra)
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://cloud-images.ubuntu.com/releases/", output["ubuntu"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/lxc --version")
  end
end
