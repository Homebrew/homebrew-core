class Feluda < Formula
  desc "Detect license usage restrictions in your project"
  homepage "https://github.com/anistark/feluda"
  url "https://github.com/anistark/feluda/archive/refs/tags/1.7.0.tar.gz"
  sha256 "6f0fadf5133ddd0d7090d5cca85fbee742335942798a5d836e47f81cb41aa34a"
  license "MIT"
  head "https://github.com/anistark/feluda.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "993b270638508c78a6ba5ec743c412d54732a6d138f02702aa9c389aad846c03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06b82c986266201e1e4e1b9523cc48e9614ffc4c94b926788ba5f3ad56d7f28e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec4b90283a9ab6f42d981d58313b7349a64a0d1747da6db711f88942423f1d9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f16a7a9eafc9cab27629c67a52006019fe2f5889ab067ef94bf057145b73b02"
    sha256 cellar: :any_skip_relocation, ventura:       "4ad15cfb4d122c11d7702c092cbbd73cd3529505880001060f899f690d2069f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4dd79e99b0e2be326a6f473cae8cf9f507b5dbf37d91d575d12062c0accf52fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26d6c8c23cf54febb03d27e7e32613c91d39e2dcc87abfb2b5c9a9f5d4042c76"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feluda --version")

    output = shell_output("#{bin}/feluda --path #{testpath}")
    assert_match " All dependencies passed the license check!", output
  end
end
