require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://bit.dev"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.7.6.tgz"
  sha256 "4119252ff4943449682b6369b66677787723351748dadc7382ffab90768e6075"
  head "https://github.com/teambit/bit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c195c0ddc40406da2845b474852b286aca6289db96f7f4d57db4079c5476bc9f" => :catalina
    sha256 "615c4ba81335ca5845520982b9f2cf62759de2d49921fe60cf62d33762567a92" => :mojave
    sha256 "089438512a0f802501cda9deee8a069aecdc5388c26d109c21dad526f4020739" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"Library/Caches/Bit/config/config.json").write <<~EOS
      { "analytics_reporting": false, "error_reporting": false }
    EOS
    output = shell_output("#{bin}/bit init --skip-update")
    assert_match "successfully initialized", output
  end
end
