class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/v0.3.13.tar.gz"
  sha256 "b2877612d5abc59e551c172314fd144c5621e42787b4451dd599f1c14a13afb3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f46dd0330f54227c000c61238248d227df416744ce1fd99b7a74b975451d380c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1016c487bc865695907f891850566d7e4c173523c3bd1a98123799499c257b66"
    sha256 cellar: :any_skip_relocation, monterey:       "e694688e96e813ad589e5adc61a236597491e92508f8e0254de767da16e74025"
    sha256 cellar: :any_skip_relocation, big_sur:        "0456a7517b517bcac4e7ee4715507a1d79eb0f03eb80984eb8e47108ad398317"
    sha256 cellar: :any_skip_relocation, catalina:       "47fadfa37f5e32411565c4975ddef9a1cca7b44b685a03cf95cfd4e873c4834c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ce876f76d9a9d2cbf20a2c5c1d162126c6ce026036cd82f42c7e76f787e0082"
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
