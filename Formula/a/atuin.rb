class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://github.com/atuinsh/atuin"
  url "https://github.com/atuinsh/atuin/archive/refs/tags/v18.2.0.tar.gz"
  sha256 "7fb87902ce09af2d29459e9158bc83c18519690d555259709cab40d9ee75b024"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8881f20ea906c9375a4a9494fef2c328dc5ffed3ed933b08f51dba5c9f1c3f9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f741344400169a4465e54096caf0a3c4272c61e5343c8053182306946c2c996"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80f71fd0735c329b3e4150f58880f4b824e0338394c8a0a2fa05bdfbd46d31a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7ccea5f606404334e679230fd6d1f136e5090b1d229954b6657f6ebfcbf19e7"
    sha256 cellar: :any_skip_relocation, ventura:        "c8a2d0594c59a593dc420e61746e7126182517025103eedc8ebab33851b00c1c"
    sha256 cellar: :any_skip_relocation, monterey:       "7352526c0409f4a538e70ed355e9856de603a9ad95271304ef17c9779c0f4d83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee2fcbdc3084214e964a4c9e7c6afda2fb6adb9598d49a073580cf3106517661"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell")
  end

  test do
    # or `atuin init zsh` to setup the `ATUIN_SESSION`
    ENV["ATUIN_SESSION"] = "random"
    assert_match "autoload -U add-zsh-hook", shell_output("#{bin}/atuin init zsh")
    assert shell_output("#{bin}/atuin history list").blank?
  end
end
