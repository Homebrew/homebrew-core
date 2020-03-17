class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.129.0",
      :revision => "529cfca87d49cd93cdd7f8abd6eea6489c7cbd2e"

  bottle do
    cellar :any_skip_relocation
    sha256 "45048b9ec42803558637eb9cd15621253851e9dc44193da1445bc157569056b6" => :catalina
    sha256 "935c559ccca2180343b90a902bec9893399a5f9279f9ec8792c812690c54161c" => :mojave
    sha256 "2be5b88191f95539ad0cf73ba0e381e0e361ceae563ec0e09d3086265e0bb62b" => :high_sierra
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
