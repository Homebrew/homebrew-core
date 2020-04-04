class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.131.1",
      :revision => "dec22cf0c8a6464390ea26b42086d242e396ecda"

  bottle do
    cellar :any_skip_relocation
    sha256 "b649921d349b7da5a371a384d56ac3fd55aab607df008ec730743518e97f04d8" => :catalina
    sha256 "9d785289e5c1024d4932fc4b7f3b75c402ed7b30f174194f77911d1574729b2c" => :mojave
    sha256 "e18a43f04302ecc7b19f80bcaf2ca8ad5b306fe1b6049fa0031a3d82cf730918" => :high_sierra
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
