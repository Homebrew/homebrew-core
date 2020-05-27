class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.136.0",
      :revision => "a48ddc38288cd64837478af230516e51dabdb1f0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f50c90018d884f009b1f75eff3fc38cb5a59c65abc77b032dcefdfd45f594f72" => :catalina
    sha256 "83aec3628afdb0035268623428b84015b09617a12b0a98642e5682f389b3cfcb" => :mojave
    sha256 "ce70e032406eefdc15cb71516e53f1a8291caf750f1cc7112bd4fd1117edd406" => :high_sierra
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
