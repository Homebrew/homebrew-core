class Buffrs < Formula
  desc "Modern protobuf package management"
  homepage "https://github.com/helsing-ai/buffrs"
  url "https://github.com/helsing-ai/buffrs/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "eb132a73a5873bcd2f06cad44f3f4f637782418e533c22c7cc60d253f122bf56"
  license "Apache-2.0"
  head "https://github.com/helsing-ai/buffrs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3dec1a6a2139b11adf776c1b97ac26645b77ab005dffb39167b56a29c874ebf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0366ceef4f160e185bcfd36de79b6458a9c98a72c0c7bdcf94cc9dd2d100574"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dd27b3e1650e250b2a4408deb4a5f1d523f145c64d10e626583f0c4967100ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce90bdc2ce5c03107741108b0c6361cc53d5272c034284481551e9be06d9ce21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5900a11e0c8d59e893af496fd20500a75c004b157268d4d1ddea55cb66abc96d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ef8b802643975acde7088877eac150257b5c5c5ef89f788a5ab9e13593ef511"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/buffrs --version")

    system bin/"buffrs", "init"
    assert_match "edition = \"#{version.major_minor}\"", (testpath/"Proto.toml").read

    assert_empty shell_output("#{bin}/buffrs list")
  end
end
