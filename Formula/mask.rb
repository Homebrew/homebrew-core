class Mask < Formula
  desc "CLI task runner defined by a simple markdown file"
  homepage "https://github.com/jakedeichert/mask/"
  url "https://github.com/jakedeichert/mask/archive/v0.11.0.tar.gz"
  sha256 "8e2ddca51c691aa7bb18e377803e68e1769a0bcef1ddb1ef510537fcbfbb863d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f41f306180943b68451ecbdafacab47f497ccfa00d95baf592c58d0068ee6295"
    sha256 cellar: :any_skip_relocation, big_sur:       "95563975f0b87651a58c01845c098b93d6d0f7dfed889bebf4364e8fdfe2ffa6"
    sha256 cellar: :any_skip_relocation, catalina:      "80a869d6a62e065235ca7057e1a0df2b5045232cd897bfc5ee7b924098d8ac99"
    sha256 cellar: :any_skip_relocation, mojave:        "a4caf4f75c456b398325a2dc24d4a9b7681559fc53a55bac2b590a179bc5cde3"
  end

  depends_on "rust" => :build

  def install
    cd "mask" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"maskfile.md").write <<~EOS
      # Example maskfile

      ## hello (name)

      ```sh
      printf "Hello %s!" "$name"
      ```
    EOS
    assert_equal "Hello Homebrew!", shell_output("#{bin}/mask hello Homebrew")
  end
end
