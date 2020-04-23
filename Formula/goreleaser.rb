class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.132.1",
      :revision => "244ca69a09735fdd712bd802ff4aefb5d5da60cd"

  bottle do
    cellar :any_skip_relocation
    sha256 "1eff0288f0a733df9d5e0c51785c0c5ff33aece871c85aee4514cc5355e8c788" => :catalina
    sha256 "6b784dac26df8e834a008984a79f53fe56053753558e6a54d1e8aae62c19dc95" => :mojave
    sha256 "8969cd5024dbc95ebf83540aca8663e8699cae2bf26290d7198ae7767dd950de" => :high_sierra
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
