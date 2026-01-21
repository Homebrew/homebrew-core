class Asciinema < Formula
  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://github.com/asciinema/asciinema/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "d07d22d9531fa98d2999dfc2ef27651efc3a4f5e5f46a78c3c306b69c466af8b"
  license "GPL-3.0-only"
  head "https://github.com/asciinema/asciinema.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9fdc83648ed5b37f69d6b53be3d1d060f057a865261cd3915e9c10635fb24d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0a73db4590fabb02ff364bee1be8fff789d65a07f075bb2311665c8d9ca01a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b82b8e50e33036e0eba554c1abe0709984de6954d361462bd2eba5029d65efa"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e01901d599e3af89e662e559423f8f16f4ae0a67daed4bfbf91242bee41c4c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6ca601ceaea2b4565e52b466d799c57aeeba764dbf3a213c75cf2299125e39c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "736b3df5be7bc6c2129aaf50308dd1311f2c336a80913f8cefb86e1c4fa6518c"
  end

  depends_on "rust" => :build

  def install
    ENV["ASCIINEMA_GEN_DIR"] = "."

    system "cargo", "install", *std_cargo_args

    man1.install Dir["man/**/*.1"]

    bash_completion.install "completion/asciinema.bash" => "asciinema"
    fish_completion.install "completion/asciinema.fish"
    zsh_completion.install "completion/_asciinema"
    pwsh_completion.install "completion/_asciinema.ps1" => "asciinema"
    (share/"elvish/lib").install "completion/asciinema.elv"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["ASCIINEMA_SERVER_URL"] = "https://example.com"
    output = shell_output("#{bin}/asciinema auth 2>&1")
    assert_match "Open the following URL in a web browser to authenticate this CLI", output
  end
end
