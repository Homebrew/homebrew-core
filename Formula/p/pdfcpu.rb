class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/v0.5.0.tar.gz"
  sha256 "d67529db954b4b8fd708ac984cf79a53baf57ab2d50ef9ee0f9188f7e4a83127"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5c4dba29b404cfc873a667bcc5693fef156d9e712a03203939142ba4afc2909"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3a700dbcc9b8f179f0eddec942c02a4d17851700abd2f5cce7d69ab7a83e6d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ab382dbe13c65804f22ca8ccda84c3c58b76fece858273c35114822dd42f5ff"
    sha256 cellar: :any_skip_relocation, ventura:        "764606b36814edaf4c5c4d56b5d2bbac5b64d7a0eb35b98ef66b225c580be7ff"
    sha256 cellar: :any_skip_relocation, monterey:       "121b4c05f3310693a9094258c888d081911cc3123b6febdcbf9ec558bcdbe3e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "434ea9d7e2ab797beebd7c59e43d6b40f8c8e22da2501e44b2772725304c87cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffc2c40994468ce444bc83edea61b02a3fa12478667f75af9e4d96e6172ed65c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/pdfcpu/pdfcpu/pkg/pdfcpu.VersionStr=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/pdfcpu"
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
