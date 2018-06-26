class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.79.0.tar.gz"
  sha256 "d8f2b3b61392a0c863b7bc9332f64685048a5912c89a10cab133bb19687e74e7"

  bottle do
    cellar :any_skip_relocation
    sha256 "4cddcca6dfe8bcc66a32564eaff0c25971e2e8dbaf90d09980b3f5f55aef56db" => :high_sierra
    sha256 "54b61039b5ff1b287bca2a7cabeecd5c5f1fad09a7b124ea43c308ef5f61ff25" => :sierra
    sha256 "85b8fabf63aea9eaa36c8b4bebcfb1eb821c6f0b0b3dd64c82aa70656cc4c003" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/goreleaser/goreleaser").install buildpath.children
    cd "src/github.com/goreleaser/goreleaser" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-ldflags", "-X main.version=#{version}", "-o",
             bin/"goreleaser"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
