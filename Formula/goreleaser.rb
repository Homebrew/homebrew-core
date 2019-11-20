class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.123.0",
      :revision => "30da2ee18207ecc706e92df4b8b0f5a11214d745"

  bottle do
    cellar :any_skip_relocation
    sha256 "90e861be77b310b0254729a9e0498305d28abea9de0b5b482c846c264b7f9c90" => :catalina
    sha256 "cbc613aab5481dfb61c57f514e48937ccdb336d645288a7f59f54947eb7683fd" => :mojave
    sha256 "78a306541094747d00b7aa2ebe63111a767b0611c173dc9491b4409ea4d87efa" => :high_sierra
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
