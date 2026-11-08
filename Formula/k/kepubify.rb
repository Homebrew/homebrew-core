class Kepubify < Formula
  desc "Convert ebooks from epub to kepub"
  homepage "https://pgaskin.net/kepubify/"
  url "https://github.com/pgaskin/kepubify/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "bd8053d3927440a9bd54022bbda697b937ab0365e55ad70b73c998233e57c030"
  license "MIT"
  head "https://github.com/pgaskin/kepubify.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(:?\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5a520c236a3f9d8dfb8055f500a2826e417072010547a74b5ed81367841d08d9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5a520c236a3f9d8dfb8055f500a2826e417072010547a74b5ed81367841d08d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a520c236a3f9d8dfb8055f500a2826e417072010547a74b5ed81367841d08d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0b43edf639f63ce668fcbdde284ad17b646d9f8e57ae1ca5c639fdd88d76cd1d"
    sha256 cellar: :any,                 x86_64_linux:      "637894bc3fff2644d4cc84b2fe5156697dc027122e4167798228b58361762529"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/pgaskin/kepubify/v#{version.major}/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/kepubify #{pdf} 2>&1", 1)
    assert_match "Error: invalid extension", output

    system bin/"kepubify", test_fixtures("test.epub")
    assert_path_exists testpath/"test_converted.kepub.epub"
  end
end
