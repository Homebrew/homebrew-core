class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https://docs.ignite.com/"
  url "https://github.com/ignite/cli/archive/refs/tags/v29.6.0.tar.gz"
  sha256 "aa84aefcd349d32bf30e12f2a1c4e9caa83f0c9066e9899439ba5e0080d9be38"
  license "Apache-2.0"
  head "https://github.com/ignite/cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72751fd958825f28c4d2bba5bcc840924ec639f17df361e030fd79deebfd901c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6687f7e0ab0f33a839a8aeeb6a7e2b4fd1130c83e13bb8ee0243ce8dbe131e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c68f2d8fb05aef5232916cdd7b4bd787c634eac3283dfb30dc990f6d31e243cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "73c6262cffd76ad28581146870fe3c23c8ead7b5ed62621087ecbc9295201e0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b98f9e3a20ea8f0a52819f66bc96adfb92d060729f562a252648b332a93cc40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8420c8c0bb06b71be99ee8c9b02fb78eaedeca876f6b2ed1cc30d7fc73165d86"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w", output: bin/"ignite"), "./ignite/cmd/ignite"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin/"ignite", "s", "chain", "mars"
    sleep 5
    sleep 10 if OS.mac? && Hardware::CPU.intel?
    assert_path_exists testpath/"mars/go.mod"
  end
end
