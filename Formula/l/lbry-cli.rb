class LbryCli < Formula
    homepage "https://lbry.org"
    desc "The LBRY Command Line Interface (CLI) to interact with the LBRY Daemon."
    license "MIT"
    head "https://github.com/LBRYFoundation/lbry-cli.git", branch: "master"
    url "https://github.com/LBRYFoundation/lbry-cli/archive/68db80d89bb263d1a4eccab2c8a86067e2b34336.tar.gz"
    sha256 "9deb1c63a8d353e21feabf00367ebdc6d33efa2cb4943423e0fa1d19f38be66b"

    depends_on "go" => [:build, :test]

    def install
        system "go", "build", *std_go_args(output: bin/"lbry-cli")
    end
end
