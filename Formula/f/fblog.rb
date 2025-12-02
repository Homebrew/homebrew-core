class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/refs/tags/v4.17.0.tar.gz"
  sha256 "6582020850aa9205fbdc4e169401c20e8ecc9b5decdc25dfcceeb955c83e3bcf"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f9a98523e3dec196e33c224b59223184f9cfacf94e4a626ddaf526155b33ca3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62bffc30c95f2b03a14790489cd9a4799c0758b1c939d96f924183582f4bab16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a125573b7faa539e156708a26273c6669a3084f892e9621253b8e2a99d8a120"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d0941dc6a14bd0f2b2641df59b40d2b548148c2f256cea10882c4ffc61b9872"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd7f946ce78bb8e3cba835ebd1029ec3b67595eaa811801fe31a3d0fb21db51f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3e7219b5976de157a8fd8fc235438177075c1d7ff4b1348930d1ab10a7abb74"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fblog", "--generate-completions")

    # Install a sample log for testing purposes
    pkgshare.install "sample.json.log"
  end

  test do
    output = shell_output("#{bin}/fblog #{pkgshare/"sample.json.log"}")

    assert_match "Trust key rsa-43fe6c3d-6242-11e7-8b0c-02420a000007 found in cache", output
    assert_match "Content-Type set both in header", output
    assert_match "Request: Success", output
  end
end
