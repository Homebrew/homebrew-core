class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/refs/tags/v1.2.7.tar.gz"
  sha256 "923a2eed637d2ea5f4ad5f820b6f87cc6e0081cfa4bc5ed1fe09278dd74db963"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "752737e1c848831cda9420cef7af7a9bf99909457e306b8d602364ed7cc6a824"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9887c9b2942bdc44f4b0671a30356f119b194b31d4cf9b2b289f32c1744fa55f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dd52b635060bb417149948f5b0ef3983730b34db7073ea50fd0fb2068c2a4909"
    sha256 cellar: :any,                 arm64_linux:       "bff26cca8439917eb8b877014f741afe1452010e216a2911e7dbe4317a672161"
    sha256 cellar: :any,                 x86_64_linux:      "6615967db2db81cd1c652b5de7af0f7d089c8f033541e724f25953e34de5f0d8"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/dust.bash" => "dust"
    fish_completion.install "completions/dust.fish"
    zsh_completion.install "completions/_dust"

    man1.install "man-page/dust.1"
  end

  test do
    # failed with Linux CI run, but works with local run
    # https://github.com/Homebrew/homebrew-core/pull/121789#issuecomment-1407749790
    if OS.linux?
      system bin/"dust", "-n", "1"
    else
      assert_match(/\d+.+?\./, shell_output("#{bin}/dust -n 1"))
    end
  end
end
