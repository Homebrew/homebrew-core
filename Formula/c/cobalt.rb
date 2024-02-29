class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "9dc1d1ca5ef32c360fae3ec0d4491f1442a627050e74ec52fbfeae181ca4baad"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03ffec3c1b59ff10d3d45a273af634aa9cdf5e2b0854c1e7db2a38bb505fb0b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83940890885860584d6cbe1586ea21cfcd842d68b31bb0a0f271863af13d7641"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a17949fa4e459f59dacd4a93570c6cd06f8c12ab5ced68ec42ced68f28f5b636"
    sha256 cellar: :any_skip_relocation, sonoma:         "70eb450753241614c6fa8ad6e56e839127572c8ae23e5be24a0486c7345f87b7"
    sha256 cellar: :any_skip_relocation, ventura:        "20c5bf60c03d519119dfe4c2e9d049e76082933e47690368ea4d6f8cdfa601cd"
    sha256 cellar: :any_skip_relocation, monterey:       "c488599c36013ba4277227cd17b3e9c00aaf95f8e0ef605df42aef5a4f040c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bea593a3207e7b6066635af8e52754a9fa13e319c8840e59b3edb884035b0279"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_predicate testpath/"_site/index.html", :exist?
  end
end
