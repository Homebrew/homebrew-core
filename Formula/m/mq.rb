class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://github.com/harehare/mq/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "f760fa96c839400c986d4ff53c25c97f7cf66fcf02725f36fffc097e446ea6c5"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "39289fada9e556a9568ac96540faa0d0999cb1996d2809c3174c858936dc27d7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "70c7abf6908f1baf540501e83f3e30fe77ff528de2fee4cf5913a0a8b95340d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "35268c0c0c64ef7be173d2a94857c083f08419a69f9afe03460b6aba24d2c6cb"
    sha256 cellar: :any,                 arm64_linux:       "2be96f7d908d498ef7e2717db33ea37e09fb0c92242cf2d59cee5c98652600bb"
    sha256 cellar: :any,                 x86_64_linux:      "0965baf0cdded551d18d8e6791cdfb1de049e3a1d6828559093d502ae154fecb"
  end

  depends_on "rust" => :build

  # Sync stale workspace versions in `Cargo.lock`
  patch do
    url "https://github.com/harehare/mq/commit/3aa2a1fa7a726770bc67b14f1123f205747ce711.patch?full_index=1"
    sha256 "c5a005532626d79b792c47b9cccfe4a9a08d7203904c0c1835a5141ebb57eb84"
    type :backport
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/mq-run")
    system "cargo", "install", *std_cargo_args(path: "crates/mq-lsp")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mq --version")

    (testpath/"test.md").write("# Hello World\n\nThis is a test.")
    output = shell_output("#{bin}/mq '.h' #{testpath}/test.md")
    assert_equal "# Hello World\n", output
  end
end
