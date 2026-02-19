class Blades < Formula
  desc "Blazing fast dead simple static site generator"
  homepage "https://www.getblades.org/"
  url "https://github.com/grego/blades/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "6bcce947580243e83a9bf4d6ec4afbc7e6cd0c7541a16d904c7d4f1314036bd0"
  license "GPL-3.0-or-later"
  head "https://github.com/grego/blades.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30c379b57bb8030e4a7502c73c8a7046e9809738f3027e761af11b23dda24536"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8cbe0edc427152920ea102e09fcf88f0807f787c019202090c22d32c5a827af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d39a8da1d1fbf7021ef3397567424f8043620a190fb444113a9816ddab1263f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "862697809bf4f3d34508e1e825583959cefeba8ae081a41e877659087786dba6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d18112bcddc915b81b66db803ffe3d0c221d618f0f1c27e7bdab6beb04b776a9"
    sha256 cellar: :any_skip_relocation, ventura:       "bd2f938978247d08a419276e60f361805b9bf24ffc64091bc21830887f184297"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d77d91ea173c7fc7a50c2c6f8dafe1f5b93710f2d085e8f90579d0718c63530"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cdae37930e4d9629f7744b9e3fc74b64ddf5eb17d109165419b8f6a3089c00c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/blades version")

    require "expect"
    require "pty"

    timeout = 5
    PTY.spawn(bin/"blades", "init") do |r, w, pid|
      refute_nil r.expect("Name:", timeout), "Expected name input"
      w.write "brew\r"
      refute_nil r.expect("Author:", timeout), "Expected author input"
      w.write "test\r"
      w.write "Y\r" # `Start with a minimal working template?`
      Process.wait pid
    end

    assert_path_exists testpath/"content"
    assert_match "title = \"brew\"", (testpath/"Blades.toml").read
  end
end
