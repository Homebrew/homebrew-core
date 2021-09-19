class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/loadimpact/k6/archive/v0.34.1.tar.gz"
  sha256 "64225494aff029dd10f434fd5cb6ab232446c97208bdf9127e195e4d8615d83d"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cddd9cf3e6fa0cc99888362ba4d6968ea433263b49fd61500d831467036d861a"
    sha256 cellar: :any_skip_relocation, big_sur:       "24b67060719ff01398df450081a25705e837580600faa268230080e0b2fa67d2"
    sha256 cellar: :any_skip_relocation, catalina:      "e4d8fac6423861809354f1788e64b7a2138295997b31abbc28a6e9300552a056"
    sha256 cellar: :any_skip_relocation, mojave:        "7d3a83df3bc716adcb736075f3901ed0d4d9f3f8524bae2ec3f739f101fb8068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a01ec855c402b99acfc9dedc3eb6809b7f46973e8213523e56ee266a7d21cfdc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
