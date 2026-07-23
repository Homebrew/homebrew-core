class Kalker < Formula
  desc "Full-featured calculator with math syntax"
  homepage "https://kalker.strct.net"
  url "https://github.com/PaddiM8/kalker/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "91749c767e345094a2c2057cfcf722d9aed24583381c175bdbd838a5ec00d1ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8932c34df1dda8d3c222f4dea03a37bbdcdf92f95106a8cd5ab39ad5d99759c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e549d7b6a386547d1a54910badaa412e6ccde3ad3d1536ee87ef08f859990204"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b8d413f8eca947dc5566c97817815e7f1dc68df500659eba6cd312129aeee4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "050d57ce28a60fe127c75baaaffaf6ea1d683d398a6b8e0d2d8abf3061798373"
    sha256 cellar: :any,                 arm64_linux:   "c104e5216ec1ca2c8e297e3c5985f01c42ee25dccc71bcbcc7c95fa8dc79702e"
    sha256 cellar: :any,                 x86_64_linux:  "04a6668128d9ed53c94b58cbe8a515e17ca31afd97ebf2349e3f62e4bcf3922b"
  end

  depends_on "rust" => :build

  uses_from_macos "m4" => :build

  def install
    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kalker -h")
    assert_equal "= 15", shell_output("#{bin}/kalker 'sum(n=1, 3, 2n+1)'").chomp
  end
end
