class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/refs/tags/v2.37.1.tar.gz"
  sha256 "f39685ad5daa9deb65c05147267f779fb3289533053d44afc828ed1f71d6ec5c"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e860119a072e48a3465d91030505681dd212ca196ace9175fcc39b69fdafef37"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35a8fb122b3ee41b6213d57b5ad96e7d0fe8d686f58615a7f0d2ecd23cb04dc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3018eb93bb9ba167e639432ac28be5ea4b88e956ffc56e820d24ce837588dca6"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ccbcbe1e7cd2b3ec4a910aaa5432acf5fca60d8cc86c2ec4c6c7447e5093e32"
    sha256 cellar: :any_skip_relocation, ventura:        "35ba741a201dbd1965e2443a0e4d7d5cc8c1085434f481ee88021e78e3e1adf7"
    sha256 cellar: :any_skip_relocation, monterey:       "fe967dc521b9c65bc85d862a573f412a4031cc78ddf30109448b936e488124bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "265b9da5cb5c3d246d6ac2d0ca8ff6d24cf9cead6f419032b8f6be6d9daf3df5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/nfpm"

    generate_completions_from_executable(bin/"nfpm", "completion")
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/nfpm --version 2>&1")

    system bin/"nfpm", "init"
    assert_match "nfpm example configuration file", File.read(testpath/"nfpm.yaml")

    # remove the generated default one
    # and use stubbed one for another test
    File.delete(testpath/"nfpm.yaml")
    (testpath/"nfpm.yaml").write <<~EOS
      name: "foo"
      arch: "amd64"
      platform: "linux"
      version: "v1.0.0"
      section: "default"
      priority: "extra"
    EOS

    system bin/"nfpm", "pkg", "--packager", "deb", "--target", "."
    assert_predicate testpath/"foo_1.0.0_amd64.deb", :exist?
  end
end
