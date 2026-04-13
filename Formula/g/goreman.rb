class Goreman < Formula
  desc "Foreman clone written in Go"
  homepage "https://github.com/mattn/goreman"
  url "https://github.com/mattn/goreman/archive/refs/tags/v0.3.17.tar.gz"
  sha256 "56c9004156d10d60fef810409e7af4b9b99a4419f52d8a878611afb04be8fde0"
  license "MIT"
  head "https://github.com/mattn/goreman.git", branch: "master"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2f63132febc2b572bcbd1b1df8437f07e93d2582fb68ce52ac59bea93e08a88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2f63132febc2b572bcbd1b1df8437f07e93d2582fb68ce52ac59bea93e08a88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2f63132febc2b572bcbd1b1df8437f07e93d2582fb68ce52ac59bea93e08a88"
    sha256 cellar: :any_skip_relocation, sonoma:        "5548a5e6da50cd4a4d254bc310377d5dc80bbc359becde8bc6942fa30283266d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f70d8ca6a25c671bd12c5ccb1bca21278fa0c9bf9f6929f21fe85ff8e4469341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b34336b61cfc0a914e88c4abf36f0332eb1c19b1135d620d4906d0656b7975ee"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"Procfile").write "web: echo 'hello' > goreman-homebrew-test.out"
    system bin/"goreman", "start"
    assert_path_exists testpath/"goreman-homebrew-test.out"
    assert_match "hello", (testpath/"goreman-homebrew-test.out").read
  end
end
