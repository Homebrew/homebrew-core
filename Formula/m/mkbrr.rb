class Mkbrr < Formula
  desc "Is a tool to create, modify and inspect torrent files. Fast"
  homepage "https://mkbrr.com/introduction"
  url "https://github.com/autobrr/mkbrr/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "c25a6fe919eff6d21237489da26ab986bade544219dd5c9a47b6038f3f782d1e"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/mkbrr.git", branch: "develop"

  bottle do
    manifest_sha256 "38dd4f81a1138231d52d89dec32cabe7e405c92d6bad8e9d933e10ba5a78baf3"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f0fb37fba29de3e8a390dac3248e381bd83616bc04b90abaa01699659ff16737"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f0fb37fba29de3e8a390dac3248e381bd83616bc04b90abaa01699659ff16737"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f0fb37fba29de3e8a390dac3248e381bd83616bc04b90abaa01699659ff16737"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "788e56b26d05c536d2a0080ba4e1aed98a8cc5ae6f2204ade71c985bdc61cf80"
    sha256 cellar: :any,                 x86_64_linux:      "a4e599283424dca6dd4e86cd74fcc89da529976495c16bb5cb534b517cfeb275"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mkbrr version")

    (testpath/"hello.txt").write "Hello, World!"
    system bin/"mkbrr", "create", (testpath/"hello.txt"), "-o", (testpath/"hello.torrent")

    assert_path_exists testpath/"hello.torrent", "Failed to create torrent file"
  end
end
