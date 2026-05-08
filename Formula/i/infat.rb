class Infat < Formula
  desc "Tool to set default openers for file formats and url schemes on macOS"
  homepage "https://github.com/philocalyst/infat"
  url "https://github.com/philocalyst/infat/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "ad32dd35fd8f6f77648416ff26504faab308c63de895cb3e45ac622eda71a9d6"
  license "BlueOak-1.0.0"
  head "https://github.com/philocalyst/infat.git", branch: "canonical"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50de3391c0125e448685391fdb96fa518f0154837a0307bfade506fa49e59a2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc0e3f568b11130a1381fe9660e5baf4967f6953a63e3193bd74af28df0eda7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "781cf9523514f411ee6ada165e1ccc0294073e39e1437ecc872bb9fdc290b4f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a129bbde2c2c35d81b6d527deea4baad62e4a55615f542704edab700bf6b22c"
  end

  depends_on "rust" => :build
  depends_on :macos
  depends_on macos: :sonoma

  def install
    system "cargo", "install", *std_cargo_args(path: "infat-cli")

    bash_completion.install "target/release/infat.bash"
    fish_completion.install "target/release/infat.fish"
    zsh_completion.install "target/release/_infat"
  end

  test do
    if OS.mac? && MacOS.version >= :tahoe
      # From 26.4, `--ext` seems no longer work.
      # Issue ref: https://github.com/philocalyst/infat/issues/42
      output = shell_output("#{bin}/infat set TextEdit --type public.plain-text")
      assert_match "Set type public.plain-text", output
    else
      output = shell_output("#{bin}/infat set TextEdit --ext txt")
      assert_match "Set .txt", output
    end
  end
end
