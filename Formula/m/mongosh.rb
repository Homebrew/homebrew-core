require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.1.4.tgz"
  sha256 "44b11e5e02607a0cb80767a560ee639fba1964889ff366bc87583758d27f04cb"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "e14c3e92f5dce36beb22eefd87c0193e40c48cf49e1cd973a9cbe59ee0aa8731"
    sha256                               arm64_ventura:  "749d9504b14c7012588aef9119d96ba07e3cd47a3da5e2e17d4956d59cbc4a21"
    sha256                               arm64_monterey: "79b51c7d71aa3e29eac1bbbd4000d848d7198cb449a53d0428acc5b95d01e3f5"
    sha256                               sonoma:         "862ab365175967d8338412ab0671b95caa35380e31b02191c4bed1134f8f92fd"
    sha256                               ventura:        "e9303a86969999d0d1b5373c42930fed1522d4a1e230aa0d05dec79486ec5e55"
    sha256                               monterey:       "248607ffc819d547a9a21a136c7f6dcf9a8cc017427b3b34f70cb6391966bace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1412a4882dc84af9f3fdfa1d491e894814bbc66dd9835b555d2683b110ecebf8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"mongosh").write_env_script libexec/"bin/mongosh", PATH: "#{Formula["node"].opt_bin}:$PATH"
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}/mongosh --smokeTests 2>&1")
  end
end
