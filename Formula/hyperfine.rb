class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  url "https://github.com/sharkdp/hyperfine/archive/v1.15.0.tar.gz"
  sha256 "b1a7a11a1352cdb549cc098dd9caa6c231947cc4dd9cd91ec25072d6d2978172"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/hyperfine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c157190162c9057b25849321a82a93de6629132a578bbb1f1b9db7eb2f092a72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b85f7faffc4336eb2e77507f157ef6afa1e24f4190507a02b513030d3168e2e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a2ac9446129307b5a7a5a1a5597c663dd3a18224ee857a31a05397ed335526e"
    sha256 cellar: :any_skip_relocation, ventura:        "001a44956d996c1982076020a741dfe3738be52ab27630eba34fb230b8923132"
    sha256 cellar: :any_skip_relocation, monterey:       "d5a6dd6a109b445b3f7ebb40680ecc49b9d650cd5d3aec34ae02ccf87ee70ed2"
    sha256 cellar: :any_skip_relocation, big_sur:        "64699ce6a189734b72360f454983f871ea49452b018eaa1a513f6cde10a4d95d"
    sha256 cellar: :any_skip_relocation, catalina:       "20b88d7b97fef140a74964be9472b56a4f911f68ac2ffd6ce21008cd7af4db37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad705ad54d62b7283a12db3f6a6a29547b4f2fc0334be54614dff31c986b4356"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    man1.install "doc/hyperfine.1"
    bash_completion.install "hyperfine.bash"
    fish_completion.install "hyperfine.fish"
    zsh_completion.install "_hyperfine"
  end

  test do
    output = shell_output("#{bin}/hyperfine 'sleep 0.3'")
    assert_match "Benchmark 1: sleep", output
  end
end
