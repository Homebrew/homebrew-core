require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  # heroku should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/heroku/-/heroku-7.0.80.tgz"
  sha256 "510fe89398ba7e21fd6d12e4796e6b45edeff8d6118dac996b5a51453d87eae8"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4adb47b2d2390c9be987ec795ac67612af51a6692d8166db6b7fc86c64d71e6a" => :high_sierra
    sha256 "493ae1465b785d9f8e103176e322a817c90936b60de238a376ba0855b0957021" => :sierra
    sha256 "204bc820321bff8bc52b391a58615865c7f19d6ec995e8799edb94a05cfcb372" => :el_capitan
  end

  depends_on "node"

  def install
    inreplace "bin/run", "#!/usr/bin/env node",
                         "#!#{Formula["node"].opt_bin}/node"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"heroku", "version"
  end
end
