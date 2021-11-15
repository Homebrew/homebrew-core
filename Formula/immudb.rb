class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://www.codenotary.io"
  url "https://github.com/codenotary/immudb/archive/v1.1.0.tar.gz"
  sha256 "ae8785ccf13f46ed5c117798fbf353efd215fac0a5ee1b28f218cf738fdc1cc3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cf6e1570863f1796a6e18321db225ca6cdc30d212740130971a9f14c24559cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f931b7c18ac07207cb2b70823cdcbc179da97efb87927f9f2a2ea1d2255c1d5c"
    sha256 cellar: :any_skip_relocation, monterey:       "e305a2fe683861ce05e5bd92de80185a00b40a4cb94338a9102c397711eb38ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6b82b9e17f3ca35f1ef02b8f45b09a528e077e4f8371ee6df7c7b32c34b50e0"
    sha256 cellar: :any_skip_relocation, catalina:       "8fca8135de0a7d87f43f1cad5a54ab487935c997c28265054e4a4c3643c831c1"
    sha256 cellar: :any_skip_relocation, mojave:         "e2632377c4b7e139bd001a95b491a0ee39b7f2f92a7204a0410f0a1a45c0b2af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39d505304477cfb90bd846beef197f88916d2e80b12917563b7840c92a8e79b8"
  end

  depends_on "go" => :build

  def install
    system "make", "all"
    bin.install %w[immudb immuclient immuadmin]
  end

  test do
    port = free_port

    fork do
      exec bin/"immudb", "--auth=true", "-p", port.to_s
    end
    sleep 3

    system bin/"immuclient", "login", "--tokenfile=./tkn", "--username=immudb", "--password=immudb", "-p", port.to_s
    system bin/"immuclient", "--tokenfile=./tkn", "safeset", "hello", "world", "-p", port.to_s
    assert_match "world", shell_output("#{bin}/immuclient --tokenfile=./tkn safeget hello -p #{port}")

    assert_match "OK", shell_output("#{bin}/immuadmin status -p #{port}")
  end
end
