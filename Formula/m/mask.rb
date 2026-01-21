class Mask < Formula
  desc "CLI task runner defined by a simple markdown file"
  homepage "https://github.com/jacobdeichert/mask/"
  url "https://github.com/jacobdeichert/mask/archive/refs/tags/mask/0.11.7.tar.gz"
  sha256 "25df4aa1d67d4d9fb7032619951b753be51bb1ec21349316be678b3156ff1874"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f78c495b941f512448b2416170f4707e9b9d61129cc1d0f518a82215ee7e321"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4da1978c3ba6b2575b2b4018f9bb15d792a5af84675a6d4050201d72a9d665e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e94687347ff361f9f5f9ea1cc7e426339720b3302213aa4187d404cfd40fe2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "602083bfc8d94aaf1f9e7221eb71b4279672202811a76ddf0bb5815c5939b67b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf7955ac509d319009bbd593438c1d30bd8fb09eacd5bfe69950204df0090955"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ee2a5051988e4dec2a04dd15339fbadacf6c9de28af6b0cafc351b5b919b9e7"
  end

  depends_on "rust" => :build

  def install
    cd "mask" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"maskfile.md").write <<~MARKDOWN
      # Example maskfile

      ## hello (name)

      ```sh
      printf "Hello %s!" "$name"
      ```
    MARKDOWN
    assert_equal "Hello Homebrew!", shell_output("#{bin}/mask hello Homebrew")
  end
end
