class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://just.systems"
  url "https://github.com/casey/just/archive/refs/tags/1.59.0.tar.gz"
  sha256 "20f876880851f1cc67fc7eb7589c7f7ccaa7612d827feac75797cf4a6ed729aa"
  license "CC0-1.0"
  compatibility_version 1
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "96f9640b1685d567eb9892c3e83c2c4ded7a7810f04b362cfd5d1976fa9ea873"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7c906374cdd6fa3c195c0b941a2d2717257ee14022f1fef5b65491a8c3bd2415"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "12679b9c4b7427e4edd66e7e8e3dd7f5b3df1bd3470c01e95c21c5e2a10c6f6a"
    sha256 cellar: :any,                 arm64_linux:       "a4ba7c1bbcd5a25c1aa14b70f5884a6e33428724ab65df59f170908b7daf103a"
    sha256 cellar: :any,                 x86_64_linux:      "69794e026318d08aa58ae63548734cd77298bf8f3e7d1f709601f2cd494bf8ac"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"just", shell_parameter_format: "--completions=")
    (man1/"just.1").write Utils.safe_popen_read(bin/"just", "--man")
  end

  test do
    (testpath/"justfile").write <<~MAKE
      default:
        touch it-worked
    MAKE
    system bin/"just"
    assert_path_exists testpath/"it-worked"

    assert_match version.to_s, shell_output("#{bin}/just --version")
  end
end
