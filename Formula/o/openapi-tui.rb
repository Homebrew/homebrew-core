class OpenapiTui < Formula
  desc "TUI to list, browse and run APIs defined with openapi spec"
  homepage "https://github.com/zaghaghi/openapi-tui"
  url "https://github.com/zaghaghi/openapi-tui/archive/refs/tags/0.10.0.tar.gz"
  sha256 "59ab143671843c5dc16056900b3c2413cc58a943f545ea2d94d687568410cb30"
  license "MIT"
  head "https://github.com/zaghaghi/openapi-tui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9941766f4196d657a627a0851eafefe7768b3ea9d89f218ee6c4af2ce6bc2eb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6a9e012f347abbcd0b38b8bcf53674e5f7c2dd51294174c66d25eeea781f3e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ff2ddd6018645adaa1a0a881515ac08d6a061f43148b94c37a76305d16755bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "de70ffbb0ed0fa22df1a45f8863aa9350f67660fd4095514905bd4af0ca51bd7"
    sha256 cellar: :any_skip_relocation, ventura:       "774491ab972657bd8d0ef196856af801c460b847bf3a302390979dd39ce82cc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3842321b1d33f79a91d6f3eab8471593975e0e0f314b17eed04da502855e1afb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openapi-tui --version")

    # Fails in Linux CI with `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    openapi_url = "https://raw.githubusercontent.com/Tufin/oasdiff/8fdb99634d0f7f827810ee1ba7b23aa4ada8b124/data/openapi-test1.yaml"

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"openapi-tui", "--input", openapi_url, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "APIs", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
