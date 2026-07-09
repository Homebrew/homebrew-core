class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "1f417ab81c2af9f44aff53a4e7ca31053b4a93b572fb82bf49b0c30c804c6dcf"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63e084d95f57f269e32dd020556ddc82fdf1d3d239889bd9d7b1ff6fc465366e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7817ebfa3a076e2f7a17c09460e10d631d7d16bdf6a2bab5bda6b3b12fab21a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c50f35287acf7c229b92def0a7024eaa7ab2afc733ba1bf61faddac5353b8cc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ca8b4c367152667a8da0453ccde84d1e18e1454267618f1c692ff3c49b06da8"
    sha256 cellar: :any,                 arm64_linux:   "13ad2b7140f3a2766054ecfa10feec9b65222af9270509186a8c5f28d608a70a"
    sha256 cellar: :any,                 x86_64_linux:  "a4747795b143bdfbdb3b4c539900368222a9599b79137393b19197897b049af4"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end
