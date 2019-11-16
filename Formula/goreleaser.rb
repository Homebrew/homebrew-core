class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.122.0",
      :revision => "173edbac545df7796ca2c4eb5ea3a1817920b562"

  bottle do
    cellar :any_skip_relocation
    sha256 "172c1680e4b1787d6002c4a55d16eb7c2828ebc983168835faca4ceb693fa71d" => :catalina
    sha256 "849a39f8b0f749dbb8c70314168c61b74b2cfe7c76f1d769ca2092f628b17dcc" => :mojave
    sha256 "f3d81dcbed665e6e6bc0ea1a0ea00ceb5071d24f3e03ba80bdf0e6e3e264c79c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
             "-o", bin/"goreleaser"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
