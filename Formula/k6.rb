class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/loadimpact/k6/archive/v0.31.1.tar.gz"
  sha256 "449584777160096dbcfda5a7877aa21161958ccd3393c68262bb8e234647db1c"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "341acd3abfbe17f3f996a7b09643e12bd1945734fb22a2278a259ff6d407345e"
    sha256 cellar: :any_skip_relocation, big_sur:       "04b202b8ddcf6d8f9c3fbd690f4afdd9fe2f93d42e9b638a4d6362b43e4bfba5"
    sha256 cellar: :any_skip_relocation, catalina:      "35f8b9f837e3e1aea7a8e5df0a2fb21e1ba1888f55dde659989f70a6e0d7ec2a"
    sha256 cellar: :any_skip_relocation, mojave:        "cb169f9a2012619aec625cbcdea9b654da0fb98c50e926f027598be0eb776de4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"whatever.js").write <<~EOS
      export default function() {
        console.log("whatever");
      }
    EOS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
