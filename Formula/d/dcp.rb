class Dcp < Formula
  desc "Docker cp made easy"
  homepage "https://github.com/exdx/dcp"
  url "https://github.com/exdx/dcp/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "7d9caa94c6a099762f367901cb0ccbe63130026f903e5477f4403d0cfff98b53"
  license "MIT"
  head "https://github.com/exdx/dcp.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "08061eec2befb7c29aed3087ba5e6ac7a6459410d80c5630d0b47efd3ba65ba0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "cb44281e662eb5bae136d9e3d6d6e0b84b230fa0622d0b3abab0a60bae216fa9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a86398dd892b4756ffcfb7d9c6027b6cd4fa9e1372b3e6ed7a3a83b85cd7b6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c19bb89a51b9907d81b97a6ed2a2535f2c1833db9abab6d86fa3d7bdebf35212"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80dea57c8adb3236af493486d9882e0552f3a53a7bfe5ba06c452778b152129d"
    sha256 cellar: :any_skip_relocation, sonoma:         "5609d9e502179089eb3822add208ff8e14643d3cb7f47ef2691f9760dff81647"
    sha256 cellar: :any_skip_relocation, ventura:        "c81ed8916ea09601f859c03baa6adb8356aa5377f461144beefb8aa6eb9f76c2"
    sha256 cellar: :any_skip_relocation, monterey:       "e35a830f17b84a9a76f9d559bb4b8fefd775be1386e2448863f362c8b55862ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3b17162fddf2af0a22a18023eb38288ed084201a241572cb7a3bb66cbbe615b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8559472fddad82054a7b8d277036a6b45d75ea986e9df3196da8514678e6993b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/dcp busybox 2>&1", 1)
    assert_match "docker socket not found: falling back to podman configuration", output

    assert_match version.to_s, shell_output("#{bin}/dcp --version")
  end
end
