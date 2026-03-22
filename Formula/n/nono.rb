class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://github.com/always-further/nono/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "e48ec3d15d74994da67ad4d41dbeb3654ef9e10241c0de621e3a20a5bb9651df"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef367da2f56e547c6cbfb42cd2d89d5abfad91e1733e247919c30570db7cc3d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aba3471aea7b706a51442ee169d10b245d0462ebd71d9b038fa9bb03254e4cfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96db0fe83b64a7619d359a880311f268aaea8ea5e85e1719d0e5f8f65193b884"
    sha256 cellar: :any_skip_relocation, sonoma:        "581d8ddf4da978bc8cb813515db86ce53790f7e8a18ef0eeafd1deb430ba7e42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7230900bd1d66d93eee44224914d4b93ccb343f9f3b02e68d4803d3e97525614"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b75426b81604faf9ecd8ee0790512d6fc669954d33e28b2429f1f6756aea3e7"
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
