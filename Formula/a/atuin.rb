class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://github.com/atuinsh/atuin"
  url "https://github.com/atuinsh/atuin/archive/refs/tags/v18.0.1.tar.gz"
  sha256 "f9e4af24a78678d9d4283912561977aae7caf10b8dbcb3a468a09efa2ffcc1a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "afb0d600db886ab0353c594f7a4dd7de0f3055217aef10161303169aa93f20e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b9f455cefd4535937b3da88fa7198c3694fd9b9bc6844113b2409873ee71a3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9551febf8308e958ec9da061b36c734ff95447ec3d89d516f9cf3f9aa6668313"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6fd08c6b54e893107d1f179191023b07aeae1294912ba28a6efdf96d4b7611a"
    sha256 cellar: :any_skip_relocation, ventura:        "dba99ae944c82af9140d26fdc913fc85c1042c0a8698ee6f65c14876c6b32c8c"
    sha256 cellar: :any_skip_relocation, monterey:       "7678bd283735f011561ccd445692272fafe78857f208e620a016a8597f59e4d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "744930b5bcec0aa528faf3e5bfc64baca6b494c29416c7e8438f22386864afd7"
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
