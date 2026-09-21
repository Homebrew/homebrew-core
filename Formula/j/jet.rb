class Jet < Formula
  desc "Type safe SQL builder with code generation and auto query result data mapping"
  homepage "https://github.com/go-jet/jet"
  url "https://github.com/go-jet/jet/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "1a2643f234345faca6d4ceeedef45db70235f92ff09bb67636496baa95235803"
  license "Apache-2.0"
  head "https://github.com/go-jet/jet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8a57bf4aa057af3b7ad99ed723e6f233d2227e1900224eb5b7a9973376d2ef42"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0eec7a6fb4ed36617aeb4af6d58aa34c2486b773eebcca79b39a719bbfeab496"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6dbfa0bea2d082d1997ad162ddae00dca7c99e722076b4df7a2ffd619fd3616d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "556ddcc2eb3e01e038735ebfc14918fabd26211bbec778ce40212a414a77d33d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "aa66fdeb211d39b2ac45ed6ec96fa45212479e9a2a5dfc22b5e8efe2eedd30f5"
    sha256 cellar: :any,                 x86_64_linux:      "a650ff5269da5566877b616e892ff809b408b3e8ffab93a27d4e29b42a6a19ac"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/jet"
  end

  test do
    cmd = "#{bin}/jet -source=mysql -host=localhost -port=3306 -user=jet -password=jet -dbname=jetdb -path=./gen 2>&1"
    assert_match "connection refused", shell_output(cmd, 2)
  end
end
