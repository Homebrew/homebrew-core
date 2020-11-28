class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.148.0",
      revision: "1da3eeb5dc4351bc7d61ca1a1a3d9c68609edbc0"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "315d7f4c9743c64e6dc7f6cb4d6cc2989a3a4151dd9e8c32a48ea1689645d32b" => :big_sur
    sha256 "603f55f4f93607d2b47e72e3d2a5282628cffe9c997b85eb02e6389f2798dca4" => :catalina
    sha256 "99ac34034eda1992657110082d2c33eb93757a3e1ca27800193234a48773f2c6" => :mojave
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
