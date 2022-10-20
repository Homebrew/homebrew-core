class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.20.0.tar.gz"
  sha256 "d547f7e536e64a571928b443da100005d51eba7ba59caa6c490cd577b31f8cd7"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "823b8e640b4fa03b0f627c1bb5c88ea33fc344146aa7b5c7dd8c4716ea7d598e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b121475091d526493c5feb4d9fdbe74fbf9f06a4111b527ec65bad90fe1bb0fd"
    sha256 cellar: :any_skip_relocation, monterey:       "7f30f40ce1686f4f5c124d6adaac5dd2a58d8b9bfc6591dd4f85ce6d1d169453"
    sha256 cellar: :any_skip_relocation, big_sur:        "9376e537bf15fd09afa34cefcf7e5392d11c56781a63cbe396fd1907e2c40780"
    sha256 cellar: :any_skip_relocation, catalina:       "e02743b9ceea4925a0b609344c62c037c2bedaaeda504e1cd712ab5b2ff8377b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a3deab8653a897b28353d74c78afbeb4166390c6c3f2da8454525e75ff56dfd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/nfpm"
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/nfpm --version 2>&1")

    system bin/"nfpm", "init"
    assert_match "nfpm example config file", File.read(testpath/"nfpm.yaml")

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
