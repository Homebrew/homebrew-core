require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://bit.dev"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.8.8.tgz"
  sha256 "25d899bacd06d77fad41026a9b19cbe94c8fb986f5fe59ead7ccec9f60fd0ef9"
  license "Apache-2.0"
  head "https://github.com/teambit/bit.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "616bf52a2d9e825320d9aab1af3603ee79e43f6d1455abd09576691049b70f0e" => :arm64_big_sur
    sha256 "bc1b85c6100f4c5166eda34de5a92b66d73f45336536ed08921926dbb90ef6d8" => :catalina
    sha256 "c9fe18470becb44f6580e36bd3e9bc52219a1d4f111d271382942304c435cd86" => :mojave
    sha256 "2e2f871d7759adb7d2772a8ec319c3762c3e54e58625172f4ad44132cbdf3b2b" => :high_sierra
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
