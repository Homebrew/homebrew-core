class Jiq < Formula
  desc "Jid on jq - interactive JSON query tool using jq expressions"
  homepage "https://github.com/fiatjaf/jiq/"
  url "https://github.com/fiatjaf/jiq/archive/0.7.1.tar.gz"
  sha256 "fdb4a16d6965bbe5f5d053c14d75d221d90dded82f57db2134c5861bf3b8ee3e"
  license "MIT"

  depends_on "go" => :build
  depends_on "jq"

  def install
    system "go", "build", "-o", bin/"jiq", "cmd/jiq/jiq.go"
    prefix.install_metafiles
  end

  test do
    (testpath/"script.exp").write <<~EOF
      set timeout -1
      spawn jiq --help
      match_max 100000
      expect eof
    EOF

    system "expect", "-f", "script.exp"
  end
end
