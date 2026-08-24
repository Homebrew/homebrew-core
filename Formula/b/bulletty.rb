class Bulletty < Formula
  desc "Pretty feed reader (ATOM/RSS) that stores articles in Markdown files"
  homepage "https://bulletty.croci.dev/"
  url "https://github.com/CrociDB/bulletty/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "93b1da89b46877ee34b2f1688bcf052411c67c74d0e09299adee38ecd86309e5"
  license "MIT"
  head "https://github.com/CrociDB/bulletty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14ed4c48e3f0d408e8cf56be080fe8ddcb2e68428bcece3c4eb3374579989678"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62fb22c209af2e9f9f7e18a854511f8ee8c36bd6a67bebdb23a34a82e694033f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12cd2050300c25076bc92365e303723a5fb67b208b891d319eeb46111a60e304"
    sha256 cellar: :any_skip_relocation, sonoma:        "07cb7d3abef1e11c295c952430db94aed1b23aa14ea542326a2c69d115b97d7b"
    sha256 cellar: :any,                 arm64_linux:   "c279f7b7297b6917bd59d6bc45ec1037cf6f24d1e662ee4a0c62f290faacf526"
    sha256 cellar: :any,                 x86_64_linux:  "8353ca5f80d85c5dc4ffd5fcebfc9e6aa01c5395554222ce87174a8a974b4c86"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bulletty --version")
    assert_match "Feeds Registered", shell_output("#{bin}/bulletty list")
  end
end
