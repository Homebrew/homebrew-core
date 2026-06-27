class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://github.com/01mf02/jaq/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "8ad074d7e90e07ad7e77048dcf0d0e7ad434b8e3e38044260b9457d4551e644d"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "faa7a602cdd2832514c62f0678062dcec075ec7bdb6dc60d0b8f6d91f9f8179a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "174b0aec9e0df3e140fa45c465ebca534f80b722ddedd9da888672252e1105de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c19544bd0c9467ae04f96145cb5704f6f985573f19edfb7f028b21c8d0e4d77"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bd204f833f42e9704d2e0fec19955b66ce8ba7282331d253a281a6ab17902a4"
    sha256 cellar: :any,                 arm64_linux:   "e9d8daa9c15dbfefefb2719deaa117ea4fb4f2fcadf9223b399d946d8e3f1b7e"
    sha256 cellar: :any,                 x86_64_linux:  "acb82b80462ab8b13510e4843ba0a9451d47e432ebb6ded8c172d6a6a3dd65d8"
  end

  depends_on "rust" => :build

  conflicts_with "json2tsv", because: "both install `jaq` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", pipe_output("#{bin}/jaq '.a'", '{"a": 1, "b": 2}', 0)
    assert_match "2.5", pipe_output("#{bin}/jaq -s 'add / length'", "1 2 3 4", 0)
  end
end
