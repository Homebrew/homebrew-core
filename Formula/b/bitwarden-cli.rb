class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://github.com/bitwarden/clients/archive/refs/tags/cli-v2026.2.0.tar.gz"
  sha256 "ba42bd84e6d0e18e714eb2db0764bbcf78d45e7be1581ba6e05e333e4b6dded8"
  license "GPL-3.0-only"
  head "https://github.com/bitwarden/clients.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6a7a476352ef77de2af3c4ddc171ab8781ece15f90fa34dfb99fbd0b348ac1ee"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(prefix: false)
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
