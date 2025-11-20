class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/refs/tags/1.43.1.tar.gz"
  sha256 "741b5c6743501dc4dbd23050dd798f571d873d042b67bcea113d622b0c37d180"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c3194408637cdcfad22a2dd89bb56cd35fbcc363559e7ca8d9c86be52ecd8c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0f383ef0cc4660504ad1210fa6482193bacb235eecc202d32f486b6ebe91c7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8ae6b45aa7da5cb060b02e7c260fb165052008ecceb079943bed0c185adf1eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dbb471509020b01840e33b804962948fd35abedbc3506bc8d2116309640d7ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd7266f1191971c81a61d8c532bfa9f970577a8a76e92c4b71330ee406726b6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d241cbb9d54014f87912fe9bf2defc1514334616830b3a7db567c3df0353b41"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"just", "--completions")
    (man1/"just.1").write Utils.safe_popen_read(bin/"just", "--man")
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_path_exists testpath/"it-worked"

    assert_match version.to_s, shell_output("#{bin}/just --version")
  end
end
