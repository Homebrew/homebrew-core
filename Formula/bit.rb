require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://bit.dev"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.4.0.tgz"
  sha256 "03b31e947012d32baddd446142beac053e829281466f4a1689f1d98b450e22a1"
  head "https://github.com/teambit/bit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a1d4ebfe327d3b46becf83c69a9531857823484e38bff7f7d326fb59ef0c598" => :mojave
    sha256 "942e6ca172f57f87a8e5324ba03297cbb07858728474548b43d6bc9004a0818d" => :high_sierra
    sha256 "51fddaf6bcd3c32220feaa2f09d8c9f11931312788fc8ec0c8379dc571acf40c" => :sierra
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
