require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.15.36.tgz"
  sha256 "20659cb3b76e900167a217dddd7359323b40a4b0a991a338f35128fb0405aa29"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "998b44555b8f56eda9b87aa31611670e223fb52cf12e6c0c2d4535a93e59cd71" => :high_sierra
    sha256 "1cc11f395b0cbd14693f4caca07b1d0ee65701552a239420ae5bf9b7a537237d" => :sierra
    sha256 "b1829651a963a7735181a932b68defb7b7e75f2b66b37cd94ccc94c712b87cba" => :el_capitan
  end

  depends_on "node"

  def install
    inreplace "bin/run" do |s|
      s.gsub! "npm update -g heroku-cli", "brew upgrade heroku"
      s.gsub! "#!/usr/bin/env node", "#!#{Formula["node"].opt_bin}/node"
    end
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"heroku", "version"
  end
end
