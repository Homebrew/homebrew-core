class Lstr < Formula
  desc "Fast, minimalist directory tree viewer"
  homepage "https://github.com/bgreenwell/lstr"
  url "https://github.com/bgreenwell/lstr/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "9a59c59e3b4a0a1537f165a4818daa7cf1ee3feb689eaf8c495f70f280c3e547"
  license "MIT"
  head "https://github.com/bgreenwell/lstr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7c699e99285692954f204125203db1ce1a7cc27ce44c55208350acc68e33599"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79d30cf2306caa9b4273aca9c291be8f69fed25406b34b8a6bb48939d285db51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f14c9dd2c7c9ef328fac5e7646577d90e6da075e98cb1ff8937ac13793e2836"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "708b6ccf89c96dcd8b10d8d8f2f2ae578766bd517a57371df64485e21411bcb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe3a12769fa0386262c7b216cfe035271d40d0483925ecb73f627416b90dfc75"
    sha256 cellar: :any_skip_relocation, ventura:       "6b7a5f8ab810e3697d9a3cbaf5bc68ccc3ace4c1c089810ec1dc6d0761d6c26d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "201f62fce40df3217ae185a6c330cd3e736d94c91e78e7a1d3f53de2c34a50b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38a3acf97aa159c764fd9bf1e80eaeb59d5f3333b4931ee27a7668cced6360aa"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lstr --version")

    (testpath/"test_dir/file1.txt").write "Hello, World!"
    assert_match "file1.txt", shell_output("#{bin}/lstr test_dir")
  end
end
