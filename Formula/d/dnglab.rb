class Dnglab < Formula
  desc "Camera RAW to DNG file format converter"
  homepage "https://github.com/dnglab/dnglab"
  url "https://github.com/dnglab/dnglab/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "9a62c63a0775c946ccc378dbbc0f9206f593659f2f998cfb66bf6a0f64487e2f"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6410ed4f43547dc92824e6b48d006bc00be417340eea0462c6465ec1b24dca74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c61a28cf5d7d13f639076f3930ddc3997ed6b8830cc75bfed3888671c18332f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee059bfa26e1ef45495929c1b55096111957dca084d06eb1a2df92c6f7eb043f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f904d3fcb256714d1c908dd984e7232b9735d0c6912539a72848fb29851f803"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e2d67f8e56a74ae98fae362571b0d3a86f0070d4dd1af94869df10391fd4ba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e261fc76ad602c3aa4b609ce09728eb66b90fe01e473a3fa5db6cd4c89d17cd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "bin/dnglab")

    bash_completion.install "bin/dnglab/completions/dnglab.bash"
    fish_completion.install "bin/dnglab/completions/dnglab.fish"
    zsh_completion.install "bin/dnglab/completions/_dnglab"

    man1.install Dir["bin/dnglab/manpages/*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dnglab --version")

    touch testpath/"not_a_dng.dng"
    output = shell_output("#{bin}/dnglab analyze --raw-checksum not_a_dng.dng 2>&1", 3)
    assert_match "Error: Error: No decoder found, model '', make: '', mode: ''", output
  end
end
