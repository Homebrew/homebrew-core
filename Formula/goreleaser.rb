class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.136.0",
      :revision => "a48ddc38288cd64837478af230516e51dabdb1f0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8896c8fc0e17378c7828e345b448487b997569a07b3cde54649527507449619" => :catalina
    sha256 "e74abaf388f545eb64fb105de7c4ab8c6f903ca9c47d266b316908ee1a4d8a89" => :mojave
    sha256 "fd83161807b5862066eb02e767beefb72e66d651bdc63aa608533836a628f45d" => :high_sierra
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
