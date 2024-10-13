class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://github.com/atuinsh/atuin"
  url "https://github.com/atuinsh/atuin/archive/refs/tags/v18.3.0.tar.gz"
  sha256 "d05d978d1f1b6a633ac24a9ac9bde3b1dfb7416165b053ef54240fff898aded3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "78bc9e2d0723c2db65ba54664a93a4ff156970f3f1980556c0929fb8681f5636"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4db9097e63a1800f93144eb25353b8668ad5e475faefc61e72671ac02d549965"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c42852037ee57dedd73470e899ed4359374a7912df3f564b58bccfecac3b84d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2eacf66e3a212e014f9c1a086b2e032ce9de9f9d0d0fea7efc8c2b379f2c64f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b4a5c5898bab731cd6be2cbdcc34293978c89dccf96ec4b36cc4043169e0420"
    sha256 cellar: :any_skip_relocation, ventura:        "8af145234fd6a0ce710c1edd85e41b535656bd9549825702d5a89af5c475fe78"
    sha256 cellar: :any_skip_relocation, monterey:       "aca1f5a9972dc37d10a660e17f7c279fcd9251f8c8c884c861c9f35cb2e8abc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eec053b9e9bae3757a36e96164c77ef6084c3ef4882265d3d83571a9b44db99d"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell")
  end

  test do
    # or `atuin init zsh` to setup the `ATUIN_SESSION`
    ENV["ATUIN_SESSION"] = "random"
    assert_match "autoload -U add-zsh-hook", shell_output("#{bin}/atuin init zsh")
    assert shell_output("#{bin}/atuin history list").blank?
  end
end
