class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://github.com/amir20/dtop/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "71e5577f8591179c56aebd263391db10d1ccd4048f4b2c596e99240ce1067ff3"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1dcf84176092ca326103eff37583b1e429adacd8e4eeb8b632c2341b9c63abc6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c9ea5eb1075726d8373fdac151cc261780e91be5550ee0435a8f41f4deb21ded"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1a02c8696a0df8ee7b919f8f27ed495d5654e7e51e8cc4bc29835dd7c666f298"
    sha256 cellar: :any,                 arm64_linux:       "d7288ea9f0265280fd15efb155357010e9a4f91bc9b102d662973820f528eb76"
    sha256 cellar: :any,                 x86_64_linux:      "335cc3ed7f7336b190e7679b160969c41db8f550019e62b7ee4e772f123cc13c"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match version.to_s, shell_output("#{bin}/dtop --version")

    output = shell_output("#{bin}/dtop 2>&1", 1)
    assert_match "Failed to connect to Docker host", output
  end
end
