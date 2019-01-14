require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.7.0.tgz"
  sha256 "9b2325f41b6d412a6998563a7e92e49ee04e17bc2f543583b7c57249621e3f38"

  bottle do
    cellar :any_skip_relocation
    sha256 "596c4d0d1b3203d724824dd1b15ba05c704e6e8660259a6f6eaa9d7769be3ec6" => :mojave
    sha256 "8ab907c1ba25570c0563bf471eefa335cfe9c0055e4e77a5b47b95b9f65adf12" => :high_sierra
    sha256 "7e8334c0ba13423fe8cdb3dc85cc9989143863a5253e893113f515596545184d" => :sierra
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
