class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://github.com/freref/fancy-cat/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "bce101d5eb009ec9057f7b87f6ad767ee96238abcee8854a9db7febd0229a2bf"
  license "AGPL-3.0-or-later"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "15810142f9215adf37090e4e547e948953cfd167263056761c196d12936f6b17"
    sha256 cellar: :any,                 arm64_sonoma:  "15d39645779bad731c5ef9968873c9806a9a6313ded638a9900f7b23c744abc6"
    sha256 cellar: :any,                 arm64_ventura: "dedfbd59a96b3fcd14fec1cdb63684a585e65f2a6d08e8cbe102da30aec6cf96"
    sha256 cellar: :any,                 sonoma:        "fad390d814c81abd037fd34ea2b6ee41431a6335a8164b8f7d08372b73075bb2"
    sha256 cellar: :any,                 ventura:       "74a89c7239bdb993ba623a208d5f126705872716455227c934cd7eb15cbb7d6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f92383f64375613bfba99b00a6394c0e4f96c71dc054e279cfdbf8bc66c77c0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a142639f93dcac065c15a81980386912956b9c5930dce1e15d59c2a4ca1ed26"
  end

  depends_on "zig" => :build
  depends_on "mupdf"

  # Upstream fix for hash mismatch of dependencies
  patch do
    url "https://github.com/freref/fancy-cat/commit/c16075f5c5760a40f5b9d855dc6fe4ab5c91f2b2.patch?full_index=1"
    sha256 "8f4540ff942c5175df6d87bbe8c70312634a0f5237d3970e1ea5e7a9e55eba12"
  end

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case ENV.effective_arch
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else ENV.effective_arch
    end

    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *std_zig_args, *args
  end

  test do
    # fancy-cat is a TUI application, unfortunately we cannot test it properly
    assert_match version.to_s, shell_output("#{bin}/fancy-cat --version")
  end
end
