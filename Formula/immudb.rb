class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://www.codenotary.io"
  url "https://github.com/codenotary/immudb/archive/v1.0.0.tar.gz"
  sha256 "2733520d2b60698199bbb8c9a5be26d7d2319615d7d4673b422e7ae6fd60bf42"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "09529367063d75cd5d49e47322e48e408805234624e586aef11264b8cab6349b"
    sha256 cellar: :any_skip_relocation, big_sur:       "a7cb5382bf0bbd23c3c406201d6ff46a6b917233312f0f1851ebed4a3d8efb90"
    sha256 cellar: :any_skip_relocation, catalina:      "2fe1d5127c7eefd97980c9700ecfe2d0b8fa3a2fa5030e39c889314c9665bf45"
    sha256 cellar: :any_skip_relocation, mojave:        "760bc5ebf53840b82798ba3dfe8566a95edb38ad7bf0c21ab7c48e4082d16d46"
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
