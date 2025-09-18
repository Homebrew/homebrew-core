class Mcfly < Formula
  desc "Fly through your shell history"
  homepage "https://github.com/cantino/mcfly"
  url "https://github.com/cantino/mcfly/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "194383276095b71dd6d085fb959ba7981384cbe09776fd5f182e95bbed5a3a13"
  license "MIT"
  head "https://github.com/cantino/mcfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f920163beda17f623378f6bb5709fbed5d171457ca75f217a3a2d07df505d2e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a329184731d417bc6016e81b3ce19d17effb7d42350eee294e1618406275033"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ab9a0a347a17d8f178f6cee096e19721722a90852ca0b22713f3f7e0077bd4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c2fef662ad29e3b0619aa16441a538d46f5afde1c283187db41fba709b7464b"
    sha256 cellar: :any_skip_relocation, sonoma:        "236969135ed756c5ce43446daaa45ef31b7d58eab04a95cce3c70c1edf1d7299"
    sha256 cellar: :any_skip_relocation, ventura:       "e7ac96528b54c530cfc17f8dce5849e0578292757c64f329e7bbe6c97f68b2f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a41cfad3299262d345f16557a6fffe6621429fb18f3ce7b3720fcf2036df1596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cd74d143ac75a6dd064fad3f30bcecef451719fec529b40dc7ff33d2be336e0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "mcfly_prompt_command", shell_output("#{bin}/mcfly init bash")
    assert_match version.to_s, shell_output("#{bin}/mcfly --version")
  end
end
