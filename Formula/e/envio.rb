class Envio < Formula
  desc "Envio is a command-line tool that simplifies the management of environment variables across multiple profiles. It allows users to easily switch between different configurations and apply them to their current environment"
  homepage "https://envio-cli.github.io"
  url "https://github.com/envio-cli/envio/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "d0009a19dc081d3e7e1b36e8e9fdc29f675d8ac80ddd08565777e6b7d7a99bb1"
  license any_of: ["Apache-2.0", "MIT"]

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "gnupg"
  depends_on "gpgme"

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args

    man1.install "man/envio.1"

    completions_dir = Dir["completions"].first

    bash_completion.install "#{completions_dir}/envio.bash"
    zsh_completion.install "#{completions_dir}/_envio"
    fish_completion.install "#{completions_dir}/envio.fish"
  end

  test do
    output = shell_output("#{bin}/envio version")
    assert_match(/Version #{version}\b/, output)
  end
end
