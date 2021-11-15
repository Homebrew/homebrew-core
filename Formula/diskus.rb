class Diskus < Formula
  desc "Minimal, fast alternative to 'du -sh'"
  homepage "https://github.com/sharkdp/diskus"
  url "https://github.com/sharkdp/diskus/archive/v0.7.0.tar.gz"
  sha256 "64b1b2e397ef4de81ea20274f98ec418b0fe19b025860e33beaba5494d3b8bd1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81ccae56cd463196bfd65dcc54a3ffc2825fa873f38fd50e01580237ae010ce5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "faa0f912797d8e7ec10d63d74b348f453881264320753378615a06c2f57ad70c"
    sha256 cellar: :any_skip_relocation, monterey:       "f3e2388d8958e58c125fa77a085abb2e719d5ea6d75b8eafdd7db24478ca941e"
    sha256 cellar: :any_skip_relocation, big_sur:        "65524a3e2a3b3afa32a3cf5c58823ea56111baeb5898f1bf8fb7aa93aefb3644"
    sha256 cellar: :any_skip_relocation, catalina:       "b0e11173e97d885d4b4870fba646b2a6ac8451de0664d864a87e4e5fab8643a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a62be25d2877d3f68c5becbdbdb8e2fbbc74a9f37b06f6f95bf2334b8abe368"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.txt").write("Hello World")
    output = shell_output("#{bin}/diskus #{testpath}/test.txt")
    assert_match "4096", output
  end
end
