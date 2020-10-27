class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.145.0",
      revision: "ff2495fbd1578347efe00d70d80a05d93976fadb"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "3dbfdaade0e51f31e529fdf9c022dc2cebfbddceb7a5d44b7190c0503ea8a421" => :catalina
    sha256 "8d093c86e24f2052ad13863d397bb329f2be2a83892a0cdfc00a244c245a4069" => :mojave
    sha256 "255257fa6efe16d5c6136dcac3e86fc027057aa00df8fc98e9ee5275bee2421d" => :high_sierra
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
