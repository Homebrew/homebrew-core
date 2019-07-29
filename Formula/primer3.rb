class Primer3 < Formula
  desc "Program for designing PCR primers"
  homepage "https://primer3.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/primer3/primer3/2.4.0/primer3-2.4.0.tar.gz"
  sha256 "6d537640c86e2b4656ae77f75b6ad4478fd0ca43985a56cce531fb9fc0431c47"

  bottle do
    cellar :any_skip_relocation
    sha256 "42d8c134f8dde43bc127a0f5f66eda246de195604b952ed9b8ac6b3fa8aba373" => :mojave
    sha256 "f72fac01bb380b5ea55b41249b2d6bc2f799e9cb7cef55fae0a1f92e1de7ba64" => :high_sierra
    sha256 "0337aa96c5d5f25caa15177236c5f5d269adaaad01cb63a77c933eb01f7a6ed0" => :sierra
    sha256 "45ca3618888becc12b4d6be0ab9957ba5c8fdf2e818f74dc5312900c641b06c9" => :el_capitan
  end

  def install
    cd "src" do
      system "make"

      # Lack of make install target reported to upstream
      # https://github.com/primer3-org/primer3/issues/1
      bin.install %w[primer3_core ntdpal ntthal oligotm long_seq_tm_test]
      pkgshare.install "primer3_config"
    end
  end

  test do
    output = shell_output("#{bin}/long_seq_tm_test AAAAGGGCCCCCCCCTTTTTTTTTTT 3 20")
    assert_match "tm = 52.452902", output.lines.last
  end
end
