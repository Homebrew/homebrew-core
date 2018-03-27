require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.16.3.tgz"
  sha256 "10377bc015629e7eb34d40e8eb0cfe2a232a297be574d4226c413aff7c268758"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "62186eee85cde8b7c159d7ecca100d4507bfdfeded62a46c2d711ac1911750a7" => :high_sierra
    sha256 "7d096505c0c4df6161610250c688a2d08a62d32c4d4410f2d99fecd95bd956b0" => :sierra
    sha256 "70284192970acbd1aa2dd03957f90018b0b8ab1605f979c89d238d7d267246a0" => :el_capitan
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
