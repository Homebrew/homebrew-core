class PipeRename < Formula
  desc "Rename your files using your favorite text editor"
  homepage "https://github.com/marcusbuffett/pipe-rename"
  url "https://github.com/marcusbuffett/pipe-rename/archive/refs/tags/1.6.5.tar.gz"
  sha256 "41edf419ab3d7b3c16d2efe209b3ca3d3f7104a3365f61fe821a59caac31810b"
  license "MIT"
  head "https://github.com/marcusbuffett/pipe-rename.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "79ceea8ede307d9f114d6d476bc2538a9fc2dbaba609c42821ef6206057e251a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a48ff406bcb8a5357d9c53071cba3f22c1cd76dd57677c1e5eae824688eb1857"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f2226ebc20e21cf3e60864f754b16858f9142e91c075dce3f40aca885a170ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e416289ce81261b7049d6373b155523194d248e71d30578d4dde81dd2acabf39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70261a45024958a3552434d796c921342e067237e27fc49fe6434b9fc4faa87d"
    sha256 cellar: :any_skip_relocation, sonoma:         "21eaac4bb7efc7c16d23d434a51940509892ecc6b7e15e09c93c1d03b4075fc4"
    sha256 cellar: :any_skip_relocation, ventura:        "ea7df5f5f537f9b59746a41b5c54f9a84fb0fa41a7e1f120b110cdd591e65db0"
    sha256 cellar: :any_skip_relocation, monterey:       "d8c2ce2e9e90728f5e2901d0062ec2613b5f9e88b3c1d2dc3c42ebf45a2f4b55"
    sha256 cellar: :any_skip_relocation, big_sur:        "1147a22a59b737ff14028deb0c524307ff036a9953ad5f57a5568c277ce27ceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd5c54a0bdf37c614971f1dc2b5326b5b391ca0c03a86d58b50970401ea7e444"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "test.log"
    (testpath/"rename.sh").write <<~SHELL
      #!/bin/sh
      echo "$(cat "$1").txt" > "$1"
    SHELL

    chmod "+x", testpath/"rename.sh"
    ENV["EDITOR"] = testpath/"rename.sh"
    system bin/"renamer", "-y", "test.log"
    assert_path_exists testpath/"test.log.txt"
  end
end
