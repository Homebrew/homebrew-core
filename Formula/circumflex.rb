class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/3.1.3.tar.gz"
  sha256 "46895a3f77dfcb3b6bb580b4e8271a4cdc0a2db9b5f336624db08ff8e2b2d097"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bf45dc9f0aa0218541a17f04fe2a0ad3fcc2ee4421a3e4d91d46bc287b64003"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bf45dc9f0aa0218541a17f04fe2a0ad3fcc2ee4421a3e4d91d46bc287b64003"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bf45dc9f0aa0218541a17f04fe2a0ad3fcc2ee4421a3e4d91d46bc287b64003"
    sha256 cellar: :any_skip_relocation, ventura:        "0c7f860c553c119791065fd33b5fa803b3370e69963a29b12b7f9d450f41a70d"
    sha256 cellar: :any_skip_relocation, monterey:       "0c7f860c553c119791065fd33b5fa803b3370e69963a29b12b7f9d450f41a70d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c7f860c553c119791065fd33b5fa803b3370e69963a29b12b7f9d450f41a70d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2391c06f4d0b3c0fe7102ed2f1b0b8fc820938a80eee41478a04263ddd49f5d"
  end

  depends_on "go" => :build
  depends_on "less"

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w")
    man1.install "share/man/clx.1"
  end

  test do
    assert_match "List of visited IDs cleared", shell_output("#{bin}/clx clear 2>&1")
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "Y Combinator", shell_output("#{bin}/clx view 1")
  end
end
