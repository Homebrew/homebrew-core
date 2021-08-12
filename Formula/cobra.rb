class Cobra < Formula
  desc "Modern golang cli interactions"
  homepage "https://cobra.dev"
  url "https://github.com/spf13/cobra/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "382d414ff7b8f421ae07d32d5a17161718b45bdd00de86dc107a34e639857794"
  license "Apache-2.0"
  depends_on "go" => :build
  def install
    system "go", "build", *std_go_args
  end
  test do
    system "{#bin}/cobra", "help"
  end
end
