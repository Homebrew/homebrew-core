class Oxker < Formula
  desc "Terminal User Interface (TUI) to view & control docker containers"
  homepage "https://github.com/mrjackwills/oxker"
  url "https://github.com/mrjackwills/oxker/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "c4b1e5c1b45320902842e72779d4c0a5899b63e2dc0c62f8e2b2776d0873ff02"
  license "MIT"
  head "https://github.com/mrjackwills/oxker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28ac3a0434ccdb0a34f7d8e0399600e761ebcaadee06140d56d5da24d9de9214"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b237bea96ca45fe749a5b03401bb81871aa85c50d254b338eed6d67fe2bc46d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8273171e1f22ed247aa1a7892a666f2c515181b80cd3c4717de0afb38324312b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b1d72517cd96138966baa6fd7e252b26bd97e7b66ad541310a410ebf2674fbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "467e4faebcd0c81aa70dab7e8b7f1c6a0266eda20d7c7bd5f9b5ec6b7e44930b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d115bbd4839156a5765b1e36bf70965288442009d8767cf2b00f0d78c2bbfb4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxker --version")

    assert_match "a value is required for '--host <HOST>' but none was supplied",
      shell_output("#{bin}/oxker --host 2>&1", 2)
  end
end
