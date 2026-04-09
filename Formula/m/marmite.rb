class Marmite < Formula
  desc "Static Site Generator for Blogs using Markdown"
  homepage "https://rochacbruno.github.io/marmite/"
  url "https://github.com/rochacbruno/marmite/archive/refs/tags/0.2.7.tar.gz"
  sha256 "49328d4df08c964562d4b4cb61e42a5d00f88fa4f19f2967241eb32e96b623d9"
  license "AGPL-3.0-or-later"
  head "https://github.com/rochacbruno/marmite.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "514f120a07a927221e1d7b32d4bf88cd6803ccf89b0fb161f2df2c7bf0fde157"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7925bb005ab5ef0a0e4308df1372504e777bd72b48c916b755a155557f750824"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fc98400aaf655a96b5f32f94386cef05384cc9f0062d533a40e5eb29f59a226"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c66b8196d07d5505d8bca9f22418b86456e6a1a575f159c97ec278e28816e68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ca66295223c38697f46a5d5298c42f024e6aed96b3ac10f427474657cf9069c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60bfff999533244337df417baf2a6ceea6cd0de1540a2624350e552641590f8e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/marmite --version")

    system bin/"marmite", testpath/"site", "--init-site"
    assert_path_exists testpath/"site"
  end
end
