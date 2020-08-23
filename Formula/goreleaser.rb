class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.142.0",
      revision: "e014ad0ae88480406206c7758f3607168b45ced9"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c62050d65f3265cffa50be031c2df7eb2bd80878bda691bee51a29a971480156" => :catalina
    sha256 "5783aad4e2977ae895584160f84e360634f6b4b33b3c1e54b8a3841c6a7374fd" => :mojave
    sha256 "0f8074214c6da450b63da69d673d43355bb69278b5bee19e1f76357682d00aaf" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
             *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
