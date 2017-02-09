require "language/node"
class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://bitsrc.jfrog.io/bitsrc/bit-brew/stable/bit/0.1.28/bit-0.1.28-brew.tar.gz"
  sha256 "2911896ce1b1b4d12a50fe67ba53ceb35abac93529ac660e2715e499c3b1b2bb"

  bottle do
    sha256 "a3c8f1d2888e2320928dfc76ea6bc7b5b5b699929afc98fc542d0d9ac8184d40" => :sierra
    sha256 "1c8a8923bf16a13ac6a978c183d0b0a84671216942d8e2a72c19ae2b39b88cfd" => :el_capitan
    sha256 "622587fc49651195cd61471939a2c4d6aa109f3673b622c0e1ddd4d490f9adfc" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", "-g", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "successfully initialized an empty bit scope.\n", shell_output("#{bin}/bit init")
  end
end
