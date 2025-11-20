class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/refs/tags/v5.3.3_rebuild.tar.gz"
  version "5.3.3_rebuild"
  sha256 "c3bd99e02e078c81cd4c5f1bfe8d666c09fa6697b7bc14c5611e94c404b032d8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "336c371ec1eb63c7adba0085bc83a842cf0ce2364b671b4916f3fd66ef26d293"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00c9a59db44f28be5b8881f1fdeaaee14c4a9bbb88f64af340432063937d5144"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "016c32b7f78ce489e3b614ebca55c8423d128596eb69d179c5a548c77e8eabdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f1070ecae9f77da9eeddd752741253aeb35ff8ce9873adff32c0ea5ccc38373"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e5a87e330211cc6c7fafe708a14d046deabeef84807b29412a891bdf92c2497"
    sha256 cellar: :any_skip_relocation, ventura:       "81bcf9a008bd16e053b27118f8583812ca9c757f26ff86d92b674f06cf990405"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a8528cf02c89cf10683aae05c0e03bf2f1da30151f9027230dba1466ccccb1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f2a3640f0e5637c5f6f2896a87413f30a844775cdaf13753058b4a5da24d990"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang
  uses_from_macos "ncurses"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"grin", "server", "config"
    assert_path_exists testpath/"grin-server.toml"
  end
end
