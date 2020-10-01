require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.12.1.tgz"
  sha256 "8a6cdff8fa3a0c58cb35b031ef2db75c3004c7faeb4f4135693fa44e65e1ead8"
  license "GPL-3.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b4326ba5082b398b5fd6b11f8837f111756e02cfef54f6af587452dfbe5456f0" => :catalina
    sha256 "d606f871bf2ccfe4f749fbfc796603fb8973df47444443605ae0feba7c7482b3" => :mojave
    sha256 "175bb66acd1a979ba17c3d38f32edf995f5ed34a8c7f1188206ddfca0ed6c856" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
