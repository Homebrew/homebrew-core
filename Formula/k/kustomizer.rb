class Kustomizer < Formula
  desc "Package manager for distributing Kubernetes configuration as OCI artifacts"
  homepage "https://github.com/stefanprodan/kustomizer"
  url "https://github.com/stefanprodan/kustomizer/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "bba48e2eed5b84111c39b34d9892ffc9f0575b6f6470d50f832f47ff6417bf03"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/kustomizer.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "db1a9450e034758a16938409965b27bfd458ff6bad82ce621a8960c72ee6c8b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0614a810f33b3319820a68d23aee72b4af6f04d937435e2b9df8c3a6c8991caa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db4028189fa70a68b0c6c33a0837b864a9fce38f0b9e232c8adc3adfbf7a6efc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ba254b8051b47aa5f1fb36236027a7ba73cda8218c504b43065ab3ad7677584"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc06563ebe12218833949dd690e7c3ffbe71d815e16581657ba4971af6ad1a64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34ca6d21c6761b9732b0bd0cbb3bdc7bfa8c0701ba7edf2bd236f820be1ef44b"
    sha256 cellar: :any_skip_relocation, sonoma:         "49f39ea95d4c027c7ca8808b0d05258a3d6905debd124f198f34c20e95427231"
    sha256 cellar: :any_skip_relocation, ventura:        "417bce8bb8cb178b6fcc5386ecbf4a01405253abfca33c036a03f99058ce9dd7"
    sha256 cellar: :any_skip_relocation, monterey:       "826930275079d88859fd26976d3e7d8d7e9ebf57edeae256e232ce4c3603ce2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f9ac16b04e1da34901f680da8c8f481e605d374822cf77752d68777f9cd9cf1"
    sha256 cellar: :any_skip_relocation, catalina:       "e954a47cd5a1e00b299a62432ec532ddd4545a7c2de6c4d669e2242af9080eb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b48f88c7d495d1eeb79bd63cff70648d07c4ca9615fa4d9a7ff89ea3e66bc1b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ed1242aaec95d97b1c835476b50556d96a6f8902d1bcdeca14fa7625243b437"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}"), "./cmd/kustomizer"

    generate_completions_from_executable(bin/"kustomizer", "completion")
  end

  test do
    system bin/"kustomizer", "config", "init"
    assert_match "apiVersion: kustomizer.dev/v1", (testpath/".kustomizer/config").read

    output = shell_output("#{bin}/kustomizer list artifact 2>&1", 1)
    assert_match "you must specify an artifact repository e.g. 'oci://docker.io/user/repo'", output
  end
end
