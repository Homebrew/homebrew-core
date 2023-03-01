class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/v0.4.0.tar.gz"
  sha256 "c80cba8a110f49bf4c3e835043ed3b2494e3c61913c4eeacb5174f10fff3a8f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57c5fa52c3f144b2268ed4cf8fa876538b35938ea5afa5b976cc76bba8484f69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f46dd0330f54227c000c61238248d227df416744ce1fd99b7a74b975451d380c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1016c487bc865695907f891850566d7e4c173523c3bd1a98123799499c257b66"
    sha256 cellar: :any_skip_relocation, ventura:        "d63b2209ad4c98ba693ab7a3780367ede62ad01a5233909e65b7d5828679a9ab"
    sha256 cellar: :any_skip_relocation, monterey:       "e694688e96e813ad589e5adc61a236597491e92508f8e0254de767da16e74025"
    sha256 cellar: :any_skip_relocation, big_sur:        "0456a7517b517bcac4e7ee4715507a1d79eb0f03eb80984eb8e47108ad398317"
    sha256 cellar: :any_skip_relocation, catalina:       "47fadfa37f5e32411565c4975ddef9a1cca7b44b685a03cf95cfd4e873c4834c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ce876f76d9a9d2cbf20a2c5c1d162126c6ce026036cd82f42c7e76f787e0082"
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
