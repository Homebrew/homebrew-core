require "language/node"

class Jsonlint < Formula
  desc "JSON parser and validator with a CLI"
  homepage "https://github.com/zaach/jsonlint"
  url "https://github.com/zaach/jsonlint/archive/v1.6.0.tar.gz"
  sha256 "a7f763575d3e3ecc9b2a24b18ccbad2b4b38154c073ac63ebc9517c4cb2de06f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "63854f372c497e44b69bb4791389f8e6cc0e551d9b100c3b47f43c08369ebdae"
    sha256 cellar: :any_skip_relocation, big_sur:       "d70c05d6c48635034c0fa438f32c02d3b19277e22607d07f4781d3a394d27164"
    sha256 cellar: :any_skip_relocation, catalina:      "9aca65ec76aea3e9cea0bbe2ac305574a143cf07b20a612d0c34533c9970b44b"
    sha256 cellar: :any_skip_relocation, mojave:        "bff395a213ccea80834bc638e5aaa7428dd09c9dbef56d728f07dba752935bbe"
    sha256 cellar: :any_skip_relocation, high_sierra:   "1dbe9eacf1dbff45c1dcd194fc72090791a8ed2b434e783c2783adc28e6f571b"
    sha256 cellar: :any_skip_relocation, sierra:        "4ad85c01eba9de2051b70abdef8c1ba6b922725da2663681ad37e3594ff66768"
    sha256 cellar: :any_skip_relocation, el_capitan:    "20de901256ea772ee7bb13745f797e94ad3c9376e2031165c40acf4af747cec5"
    sha256 cellar: :any_skip_relocation, yosemite:      "c8ea1b10f689263798806fa33d2f004000490b9014393f2a472b0cc76d6e9ac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b86612463c369b8b32c1a7522cb48a5cb7b6c682f94042d179ed312c8eda5486"
    sha256 cellar: :any_skip_relocation, all:           "b86612463c369b8b32c1a7522cb48a5cb7b6c682f94042d179ed312c8eda5486"
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
