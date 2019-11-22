require "language/node"

class Jsonlint < Formula
  desc "JSON parser and validator with a CLI"
  homepage "https://github.com/zaach/jsonlint"
  url "https://github.com/zaach/jsonlint/archive/v1.6.0.tar.gz"
  sha256 "a7f763575d3e3ecc9b2a24b18ccbad2b4b38154c073ac63ebc9517c4cb2de06f"

  bottle do
    cellar :any_skip_relocation
    sha256 "9aca65ec76aea3e9cea0bbe2ac305574a143cf07b20a612d0c34533c9970b44b" => :catalina
    sha256 "bff395a213ccea80834bc638e5aaa7428dd09c9dbef56d728f07dba752935bbe" => :mojave
    sha256 "1dbe9eacf1dbff45c1dcd194fc72090791a8ed2b434e783c2783adc28e6f571b" => :high_sierra
    sha256 "4ad85c01eba9de2051b70abdef8c1ba6b922725da2663681ad37e3594ff66768" => :sierra
    sha256 "20de901256ea772ee7bb13745f797e94ad3c9376e2031165c40acf4af747cec5" => :el_capitan
    sha256 "c8ea1b10f689263798806fa33d2f004000490b9014393f2a472b0cc76d6e9ac3" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.json").write('{"name": "test"}')
    system "#{bin}/jsonlint", "test.json"
  end
end
