class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  url "https://github.com/sharkdp/hyperfine/archive/v1.3.0.tar.gz"
  sha256 "bab21d0dede8b437c0d4351d3959b3bfab8fe9f1d547997ed4d1d0f0c1d5801f"

  bottle do
    sha256 "947ca9a54cd659cda28443dbbc666ae93bf8671d871b9e23deb9ac98247ccb04" => :mojave
    sha256 "b58701c051461a5b6f43540cbbc5bcf87344443f72b829e43fb92056f9eb83e4" => :high_sierra
    sha256 "ba7bb49db791503d3ca178157920d086cf092b1afc676f7ed692ce04163ac535" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/hyperfine 'sleep 0.3'")
    assert_match "Benchmark #1: sleep", output
  end
end
