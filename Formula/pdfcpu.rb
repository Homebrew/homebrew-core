class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/v0.3.12.tar.gz"
  sha256 "e9f6d82460a3516691a7444d26ed339ffbe3d6307004e5340372c7ae09556065"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58fde54aac5c86c7e2abbb004c0ce88bef46493bde25331a5e1a03d7e03ef3da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b1e61ba82546a2b34a6b8233d105967117a88b9822b141b9c1da5570a5638e2"
    sha256 cellar: :any_skip_relocation, monterey:       "1722d9c9f7a1e8bb59430d98d03c7ddff9da1183dee1e8829978cf925bf9dc68"
    sha256 cellar: :any_skip_relocation, big_sur:        "64d26dfa6484ee00026f17cd54d7cb5e6a78c7b6196c2957cf66329a9af1f58c"
    sha256 cellar: :any_skip_relocation, catalina:       "67a0237f80fe1a7ccbed4e0e316bd63c721aef8323b62474e1f80d9aa63e57c0"
    sha256 cellar: :any_skip_relocation, mojave:         "7bac58c6ae404426fa9151c1ec3c2d944309792ce5c4e9a2d97d02eef4b5d20d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01947d541fb75c87b9dffbdbaa21ac6ff6132b1e4af70d1b749f54fb29046db6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-o", bin/"pdfcpu", "-ldflags",
           "-X github.com/pdfcpu/pdfcpu/pkg/pdfcpu.VersionStr=#{version}", "./cmd/pdfcpu"
  end

  test do
    info_output = shell_output("#{bin}/pdfcpu info #{test_fixtures("test.pdf")}")
    assert_match "PDF version: 1.6", info_output
    assert_match "Page count: 1", info_output
    assert_match "Page size: 500.00 x 800.00 points", info_output
    assert_match "Encrypted: No", info_output
    assert_match "Permissions: Full access", info_output
    assert_match "validation ok", shell_output("#{bin}/pdfcpu validate #{test_fixtures("test.pdf")}")
  end
end
