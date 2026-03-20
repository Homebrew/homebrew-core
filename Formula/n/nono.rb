class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://github.com/always-further/nono/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "8f7c8920b6578e57f7f61cf8c733883fddf87e8e479107d8ddf17390ea624bec"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a26299a12ce8e1d23bb769728fcb69ff4a18e99c0d03b6bf49699ffe6abce3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79f47d548d76b5856084798228ed1159ebac0f4e187e05555655a99f79a7fa8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52839570d780f3fc84b75880dce3c76be7a7f8f6799b53aff4dc108a2e61083e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6894061e6c3960e5488c90ef781c22754486ab9a8d59c8dcb18096d732c56f38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd913e0e8b2da2028507df9387b5c3d80acf892d0210eb02ab54f3fad54d3cf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9e568d0b5a1fc518da55dd3283532b499ff7949bd429f38975a9d0cf1411b41"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/nono-cli")
  end

  test do
    ENV["NONO_NO_UPDATE_CHECK"] = "1"

    assert_match version.to_s, shell_output("#{bin}/nono --version")

    other_dir = testpath/"other"
    other_file = other_dir/"allowed.txt"
    other_dir.mkpath
    other_file.write("nono")

    output = shell_output("#{bin}/nono --silent why --json --path #{other_file} --op write --allow #{other_dir}")
    assert_match "\"status\": \"allowed\"", output
    assert_match "\"reason\": \"granted_path\"", output
  end
end
