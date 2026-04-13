class Dnglab < Formula
  desc "Camera RAW to DNG file format converter"
  homepage "https://github.com/dnglab/dnglab"
  url "https://github.com/dnglab/dnglab/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "c363a5ff8c058dd6d2ffe22a2ece986fa6ad146043f0211d9b77d789083901ce"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe9618a52eeffbc84cecafa06705a9d3c806f99294f612a311d66d534a0cd404"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec5bd1c32307bb2694b4f848c01e41cd50bb911498aece379a0a69fe9d1ef7c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "723c2f8a2289e4b27e572b7500b9081535d1c15b36f94c219b53668e618c0793"
    sha256 cellar: :any_skip_relocation, sonoma:        "e13ffba5f8e11e9e23259e3f43331dee3e0ce42d9e8d77af348396ad4126b406"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f229a7e6fba3acacbbc9369c03942d1a8442753b3cead012824763874e12c7ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5aa5198b9e98a48afaec32d4eda37a4194815bb5dd198300b55901214a92d4c"
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
    output = shell_output("#{bin}/dnglab analyze --raw-checksum not_a_dng.dng 2>&1", 7)
    assert_match "Error: No decoder found, model '', make: '', mode: ''", output
  end
end
