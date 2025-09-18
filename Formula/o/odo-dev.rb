class OdoDev < Formula
  desc "Developer-focused CLI for Kubernetes and OpenShift"
  homepage "https://odo.dev"
  url "https://github.com/redhat-developer/odo.git",
      tag:      "v3.16.1",
      revision: "cd346c5e6c0d9891b06824915ed4e3281a4ecc02"
  license "Apache-2.0"
  head "https://github.com/redhat-developer/odo.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a3ffbddd7bb9552e07d227bfcf52579bb41b809ca2edb7f5072e6c2a64a80d11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "32ed81abf7115b46fcaf8f41f9b50aa1e4bc907945e575c1ebb26a9f6d30e60c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0fe7015bd9afd3f18cd9c156ce2f6b21a9dd36c3b410dd759390562e3cf7722"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6e8bb684ac9d7ec17bfbdda63d976a60316d2c48771d8267f713291142d09bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "954ce19cd59112f50bd8c4cd6b29a9fe2906f914995dd05ccdcaed6a96e29424"
    sha256 cellar: :any_skip_relocation, sonoma:         "70206faecd21320ed843d7dcd0b21db2f94961b2a38c32828d6061bf993c2c4c"
    sha256 cellar: :any_skip_relocation, ventura:        "295deb9fa449f8987e06ea32e480e6c2a253e617db227ea1db03563d515edf66"
    sha256 cellar: :any_skip_relocation, monterey:       "3002c28c9f11304b7e42efd58e26e72b972c94c7fadfd55f0bf7d776fd929a42"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a0ad1eacca24048e6260470cc6d1addc370681d26cb2b82137c84e02f932e226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9480c0fa8376a3f2b839965f2d7095fd712dd306a975032479e45419f482679"
  end

  depends_on "go" => :build
  conflicts_with "odo", because: "odo also ships 'odo' binary"

  def install
    # Replace `-dirty` suffix in `--version` output with `-Homebrew`.
    inreplace "Makefile", "--dirty", "--dirty=-Homebrew"

    system "make", "bin"
    bin.install "odo"
  end

  test do
    # try set preference
    ENV["GLOBALODOCONFIG"] = "#{testpath}/preference.yaml"
    system bin/"odo", "preference", "set", "ConsentTelemetry", "false"
    system bin/"odo", "preference", "add", "registry", "StagingRegistry", "https://registry.stage.devfile.io"
    assert_path_exists testpath/"preference.yaml"

    # test version
    version_output = shell_output("#{bin}/odo version --client 2>&1").strip
    assert_match version.to_s, version_output

    # try to create a new component
    system bin/"odo", "init", "--devfile", "nodejs", "--name", "test", "--devfile-registry", "StagingRegistry"
    assert_path_exists testpath/"devfile.yaml"

    dev_output = shell_output("#{bin}/odo dev 2>&1", 1).strip
    assert_match "✗  unable to access the cluster", dev_output
  end
end
