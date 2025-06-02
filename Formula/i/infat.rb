class Infat < Formula
  desc "Tool to set default openers for file formats and url schemes on MacOS"
  homepage "https://github.com/philocalyst/infat"
  url "https://github.com/philocalyst/infat/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "b0c0cad9dd995aff389fce829d62a61629fe8e07e7dd4a412ae010124c4cdb0d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0c6702d59949d4907d64d028e6f905350a3d5651187b5735efc6f4b1ea03be5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d50bd17575624e9009127232147d00e83d189a90f3d5c0b5b123b5945e14131"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f3e4319f818872bab982e1d4efafe6ee02a907f960a1b2aa2ca082dcd803924"
    sha256 cellar: :any_skip_relocation, sonoma:        "55e949bf1cd745eb1cc1737538460ad1230236d09039cfbec30d202067d8109c"
    sha256 cellar: :any_skip_relocation, ventura:       "587fe0d7f058a82c2f0a6d2e2226c097e0dfe22dad062b0c5770ac3e2bfc967c"
  end

  depends_on :macos
  uses_from_macos "swift" => :build

  # fix swift syntax error, upstream pr ref, https://github.com/philocalyst/infat/pull/25
  patch do
    url "https://github.com/philocalyst/infat/commit/dd050ef6f3891fe683a4f2f430c415cf0460fa2c.patch?full_index=1"
    sha256 "4efa99053e2455a39e9aa89221172a5c687f34511a4ebadeab2e136d974d3afa"
  end

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--static-swift-stdlib"
    bin.install ".build/release/infat"

    generate_completions_from_executable(bin/"infat", "--generate-completion-script")
  end

  test do
    output = shell_output("#{bin}/infat set TextEdit --ext txt")
    assert_match "Successfully bound TextEdit to txt", output
  end
end
