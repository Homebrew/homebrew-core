class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.141.0",
      revision: "bc940a90529ac9f6cf42c41081ae14a6534dcf2d"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "70340f6d2263b6633f5d998911dd43d41ac0349bd4392c60218a165b85306ca1" => :catalina
    sha256 "59fb81c27dbfeeccdf7a06200d5b35055665565d4dc4a175e4ff56cc3d8042b9" => :mojave
    sha256 "1cd77865de2cf39041ad8d1f8d1a51d8f513827d06f489225da7f6f10aab6ddd" => :high_sierra
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
