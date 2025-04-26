class Preevy < Formula
  desc "Quickly deploy preview environments to the cloud"
  homepage "https://preevy.dev/"
  url "https://registry.npmjs.org/preevy/-/preevy-0.0.66.tgz"
  sha256 "aae290aabc6046dc7770d853888dd9a7c13e57f3aa68397e249c2af608fd0460"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sequoia: "78974bbfc835ed42c5462e63bfa4436d0733864f4639c60b57beafd21367d27e"
    sha256                               arm64_sonoma:  "8160125c713db37824ba46f37b579ff95ad82b5a69f5f3d3a1ea877220831370"
    sha256                               arm64_ventura: "6e43c51cf5c2c7f9f97e3baa256e450f1d339b5057652eeb1e189ac835aaa6c3"
    sha256                               sonoma:        "da3d04b932348cbd77ee2aeef6f3cb4b580a25c2f9acde5a205eccbc95c61d06"
    sha256                               ventura:       "6e449e896eb19609d9353ea31ede1e084e173a81c5ecb8c8f949d23875112e89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45268a366541af205d7f0f6ea20684ede2ce74689e446fbf91a79192191ab825"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/preevy --version")

    output = shell_output("#{bin}/preevy ls 2>&1", 2)
    assert_match "Error: Profile not initialized", output
  end
end
