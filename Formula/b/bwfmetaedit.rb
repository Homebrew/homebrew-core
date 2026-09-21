class Bwfmetaedit < Formula
  desc "Tool for embedding, validating, and exporting BWF file metadata"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/26.08.1/BWFMetaEdit_CLI_26.08.1_GNU_FromSource.tar.xz"
  sha256 "6650b61fab0bd752b907fda5ca3bdce5bb349e12d9a6f618e8ebfc52839bbd1f"
  license "0BSD"

  livecheck do
    url "https://mediaarea.net/BWFMetaEdit/Download/Source"
    regex(/href=.*?bwfmetaedit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "55d7e9a44fb255b9fa3f4114b11e96ba776987a7d0735186e957fa51fc43b12d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d5d5d44a097ac59d71cbf6ae1b6bc5bc20db428025227c3832ef9567931d0078"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "16bab7973bacc32d3692b2d5d17401a910dc5d4c628c571bb46200d365d5eb8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "bf4bd068a5310be947bb3139461bd04d768e69490cc7e7b1fa858ce0f00a8e24"
    sha256 cellar: :any,                 arm64_linux:       "92a80b40aa5f790bf3688dc9b47e03cfd1e66ce01188db8509b4e57dd2a316ae"
    sha256 cellar: :any,                 x86_64_linux:      "f541508741ae28e5b09a9de4c90d68707a4bf8f255d078b355676b932e8cf748"
  end

  def install
    cd "Project/GNU/CLI" do
      system "./configure", "--disable-debug", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    test_wav = test_fixtures("test.wav")
    output = shell_output("#{bin}/bwfmetaedit --out-tech #{test_wav} 2>&1", 1)
    assert_match "FileName,FileSize,DateCreated,DateModified,Format,CodecID,Channels,SampleRate,BitRate", output
    assert_match "#{test_wav}: Is read only", output
  end
end
