class Lstr < Formula
  desc "Fast, minimalist directory tree viewer"
  homepage "https://github.com/bgreenwell/lstr"
  url "https://github.com/bgreenwell/lstr/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "9b9fe1c43027e6fdc04b67bd60ebfa10166797a4810bdaa9087c0aa817fd6943"
  license "MIT"
  head "https://github.com/bgreenwell/lstr.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "698ac770271e3e4f724f0f5ce2fbb7491509ae753ba4614b639ff596aaaca002"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "668d9d79e6473212253f028f33594136d578da416e9e3c62fc6d831a34013209"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e057ef25fc77c4fc75fd7d8bf486cbd06d3d8258469478b4da1c222c7733009"
    sha256 cellar: :any_skip_relocation, sonoma:        "66ba2207de2df49278428c1b13c61dae93e5e85f7320b94cb94f16244a9b9f09"
    sha256 cellar: :any,                 arm64_linux:   "d14282b60af3741b2283d8df2c4a3a975770a2b166bd8f476b13216c64e52294"
    sha256 cellar: :any,                 x86_64_linux:  "8ce0aeb14dbe84867814c0656bc9dd4e11b2a0c009328cb0e433f5e6af4dae4c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lstr --version")

    (testpath/"test_dir/file1.txt").write "Hello, World!"
    assert_match "file1.txt", shell_output("#{bin}/lstr test_dir")
  end
end
