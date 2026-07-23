class Nmstatectl < Formula
  desc "Command-line tool that manages host networking settings in a declarative manner"
  homepage "https://nmstate.io/"
  url "https://github.com/nmstate/nmstate/releases/download/v2.2.61/nmstate-2.2.61.tar.gz"
  sha256 "25cb1b4055c3f1c9d6e98c7efd3084f09d38f105b34ce6d80132d4427a98ed16"
  license "Apache-2.0"
  head "https://github.com/nmstate/nmstate.git", branch: "base"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe7693d842f55a3685575f3058770099e6e2d12c03b1490ced989dec9d4f0640"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "262bfed2939368d0728f61c7e06f5bc359d1b1bfff5d16fd450d083bb20efe94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e27e116084daa4c81fee81e25ed4b275162f428d57a599d0f7953991a837e5ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "767e856db0525b77ddff1e73237f6389230e32cbb8a697dde664bf7602aa2197"
    sha256 cellar: :any,                 arm64_linux:   "981a0dae8bb62db11f2c1c0f0610f4b8a88c4b2128471055574d89c52ef77a81"
    sha256 cellar: :any,                 x86_64_linux:  "1dc22c752a82d3fb810f142ebdcc2908557be0e02dfff394338698c195d74d9a"
  end

  depends_on "rust" => :build

  def install
    cd "rust" do
      if OS.mac?
        args = ["--no-default-features"]
        features = ["gen_conf"]
      end
      system "cargo", "install", *args, *std_cargo_args(path: "src/cli", features:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nmstatectl --version")

    assert_match "interfaces: []", pipe_output("#{bin}/nmstatectl format", "{}", 0)
  end
end
