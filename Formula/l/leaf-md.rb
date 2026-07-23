class LeafMd < Formula
  desc "Terminal Markdown previewer with a GUI-like experience"
  homepage "https://leaf.rivolink.mg/"
  url "https://github.com/RivoLink/leaf/archive/refs/tags/1.26.1.tar.gz"
  sha256 "fcff13393d749efe738688d1a31064081957e5e8712a1a883d897d3c29959c63"
  license "MIT"
  head "https://github.com/RivoLink/leaf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87a14da4a17e9244cecb042be94350ce09fa8921d352fc10d2873e773cea9836"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b5cb56c443be0f40db3d092e28a45c80b14693d3ff7acd907dedb334eef8930"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28025e1c1a1f6c0f1ef2d3da833b8a31cf2f52f30cd9b7855fae845aa30f0605"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8f61bdf15c94b0b2affdfdf4ff09f5d9bb45093664f752da935f68a8fbb2e23"
    sha256 cellar: :any,                 arm64_linux:   "51407b5b594e2966f5e153155731d61cfb44f2a161bbfb206e749173a134fd18"
    sha256 cellar: :any,                 x86_64_linux:  "5d1c73fcd81156c44bea9f897567b5320aa5fe3b5149d946a687b426d12ac49e"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install `leaf` binaries"
  conflicts_with "leaf-proxy", because: "both install `leaf` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write "# Hello\n\nThis is a **test**."
    output = shell_output("#{bin}/leaf --inline test.md")
    assert_match "Hello", output
  end
end
