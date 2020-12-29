class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.150.0",
      revision: "1b0b6be8c577be4994cc526c0a7e25d780988370"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef98a47f59fa7139fe76678ee085328a19be0a734eeb46197f5d45595f5d7b99" => :big_sur
    sha256 "6717b2c0b2f94a02e94b8a8c88c970feda84bb136b8e4cf1b92b5d9bab0f9dcd" => :arm64_big_sur
    sha256 "ec932595c140e164728f532fbc31ed7148c8f60bac76db1784cd6f4d0aeeb2aa" => :catalina
    sha256 "78a6e30e81b8cfdcf2251b69bed8478bf53160abc56884e62700f339619072c2" => :mojave
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
