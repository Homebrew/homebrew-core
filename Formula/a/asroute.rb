class Asroute < Formula
  desc "CLI to interpret traceroute -a output to show AS names traversed"
  homepage "https://github.com/stevenpack/asroute"
  url "https://github.com/stevenpack/asroute/archive/v0.1.0.tar.gz"
  sha256 "dfbf910966cdfacf18ba200b83791628ebd1b5fa89fdfa69b989e0cb05b3ca37"
  license "MIT"
  head "https://github.com/stevenpack/asroute.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd44c35000aae6f727e7014d50e6955d740d1dea628f127f7ab163566cef9ea9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5987e2552c04a0ebb4e10a3dbd990a756312e763d0f8dd5181094ad23597e34b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "163a9abd216264008582b7be4230fd4b25499c98df63428cc6712688e7864a26"
    sha256 cellar: :any_skip_relocation, ventura:        "71c97603b26dc9288ebb1dfa8bcbac7f24b3ce7e3f05e6ad896da27420cf23c2"
    sha256 cellar: :any_skip_relocation, monterey:       "1c25bfabb04bf68c00afa5b1cfe58dde4da17f666aaf4342f43db0a887e4c254"
    sha256 cellar: :any_skip_relocation, big_sur:        "96074d1e87efc94a13cca8a1afb4b2ae5ba6379c30bb5fd0ec4d635c9f97f84a"
    sha256 cellar: :any_skip_relocation, catalina:       "c3129df660d27e0bb0ac8ff5252c8d973402e613f2345e12a8621ed3a2f69809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d188308819d803382363c7a89e9aa531721a65c05fdba1092b4e08791caa4254"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bin.install "target/release/asroute"
  end

  test do
    system "echo '[AS13335]' | asroute"
  end
end
