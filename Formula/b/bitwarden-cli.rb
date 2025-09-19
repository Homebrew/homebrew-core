class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://github.com/bitwarden/clients/archive/refs/tags/cli-v2025.9.0.tar.gz"
  sha256 "4a970c053035550fb5b44fedfbf45dce490f873bc0a397540597a5bc49af022e"
  license "GPL-3.0-only"
  head "https://github.com/bitwarden/clients.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "576607fe1192baf2be7f084c7fa36d956d257ad4b89a62441bbf6619b6ed4e27"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(prefix: false), "--ignore-scripts"
    cd buildpath/"apps/cli" do
      # The `oss` build of Bitwarden is a GPL backed build
      system "npm", "run", "build:oss:prod", "--ignore-scripts"
      system "npm", "install", *std_npm_args
    end
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"bw", "completion", "--shell", shells: [:zsh])
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output
  end
end
