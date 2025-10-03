class Mask < Formula
  desc "CLI task runner defined by a simple markdown file"
  homepage "https://github.com/jacobdeichert/mask/"
  url "https://github.com/jacobdeichert/mask/archive/refs/tags/mask/0.11.6.tar.gz"
  sha256 "e76ae20a120c3ab44f1b14e73ff3f1b39d900bc66f8d2dab7fed4706bacd92fd"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fc675f86cf32075e473de596a5598310bf3e85142484b7fd66c09ef74f74182"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e768bea1c18237750a02152f2fa20f8bf243fde010b658312c760734d61d823"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b55cb4b9ba4a0cac458d0547cd61601bb75f64c11924bbe5c3ce922323a3f2f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a57f97c20bee8a3b8b2ad860777cc9aa320b44542bb902ece6f2ab1454ee53ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "86c1ce171772495aea38cb4cf6d9f68e1bffd448a758bfe85cb3f923434a50ce"
    sha256 cellar: :any_skip_relocation, ventura:       "f277b06ae9eacae3d0ed37abeb2ba5d5772583abe67cadebc18bed0cedb93efc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "089ebe9bcd0d1d5b4a53673e4bafc38964e83bca4a9dd0f3192b9684b126f900"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "293cfb240fcd5da53a9f141ddd6dbdd1f4055c8941c47b60e1753cd418be776a"
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
