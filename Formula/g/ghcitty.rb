class Ghcitty < Formula
  desc "Fast, friendly GHCi"
  homepage "https://github.com/mattlianje/ghcitty"
  url "https://github.com/mattlianje/ghcitty/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "d38c1c030351f18f4d35e6ccf2be2d8e9ba388501b5f4f6de8b7f2574a254c58"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c032fe52845c09a4e0060ca069654e3d8040938e09ffae30a11d9f4baa9fe8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "660748c0dcc151ef38a6e90290e82f88a37335d428e2f120826ba30a2d178570"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a8eacddfc7f17fff0cb4bddc55ffdb96a2e41958bbff6b43172fdd7d05fa189"
    sha256 cellar: :any_skip_relocation, sonoma:        "33ed928e52c558faa71991d4e34beb3001c5e6aef080f5ef7a213d2518baf530"
    sha256 cellar: :any,                 arm64_linux:   "97c2d267f8ded96f071276d288de59af7d53b11a7590dfd7fad0eada0107d8da"
    sha256 cellar: :any,                 x86_64_linux:  "1e5077aa314e3d6b8f68182a226fdf628ebb7a27828e7720f3ab756aecab0a86"
  end

  depends_on "rust" => :build
  depends_on "ghc" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghcitty --version")

    assert_match "[1, 4, 9]", shell_output("#{bin}/ghcitty eval \"map (^2) [1, 2, 3]\"")
  end
end
