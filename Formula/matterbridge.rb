class Matterbridge < Formula
  desc "Protocol bridge for multiple chat platforms"
  homepage "https://github.com/42wim/matterbridge"
  url "https://github.com/42wim/matterbridge/archive/v1.22.3.tar.gz"
  sha256 "21fe0755503b89cd2cc6b4c65568d9252d4bcd387061ed278bfe7debee881a74"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cd030901a37b2c5d651308b180fdb2bcbab2cd3f76de78a9175d88834aa9f2de"
    sha256 cellar: :any_skip_relocation, big_sur:       "6f9b08c117721b2b1d5bd4500fe89cb5df4fd518c9f21c4ddd6ff8e9b6810cf3"
    sha256 cellar: :any_skip_relocation, catalina:      "8ca1c58e290c072b57ee2a743a59790bafddd58a761adc9cb4ccce2c2514f89b"
    sha256 cellar: :any_skip_relocation, mojave:        "f5dce95c9872d43d61edf07ae27d8d7cdbf551ef53dac9885fc504671f6a60ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ea2db093cc24b871ce0cfab44781681d6ff1e171065467d106109e74d01fa1c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    touch testpath/"test.toml"
    assert_match "no [[gateway]] configured", shell_output("#{bin}/matterbridge -conf test.toml 2>&1", 1)
  end
end
