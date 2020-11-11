class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/loadimpact/k6/archive/v0.29.0.tar.gz"
  sha256 "1ffb392c6c83e4c688a1043608bf3bc06dea2b328a6ab0334e9ce33bd9e60d4a"
  license "AGPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b7ab6f424658d10e9c08b8981e8bd13661191ad7582a8a8dfa6dc4d4de2377b" => :catalina
    sha256 "f1ba8bcdf1f06986d8a69dda23771ccd5c10f07a5aedfa94b72c52793ec71b49" => :mojave
    sha256 "fbcaf23570c3d77669a7d630333a94bba56b82464183661c5ee20b506d979efd" => :high_sierra
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
