class PipeRename < Formula
  desc "Rename your files using your favorite text editor"
  homepage "https://github.com/marcusbuffett/pipe-rename"
  url "https://github.com/marcusbuffett/pipe-rename/archive/refs/tags/1.6.7.tar.gz"
  sha256 "011d8ec263af85a9c2037098b1d5bf0ee271a3c1731e6de597bf02ccc81b55a2"
  license "MIT"
  head "https://github.com/marcusbuffett/pipe-rename.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8886d9edd07b147fbf3ce064fc16e76dbf8e6743adcf51e430a96840a4ad8d37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d21af83ebdd3f7b5469630cf427f33bdab6dc981663a81eb16a0a326e8df434"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cec1a4fd195e350bdd24cf90802188a33b161c570dff6045683272021000efea"
    sha256 cellar: :any_skip_relocation, sonoma:        "a03aa9abc0ed27030089de75e0c528e2a556526441761668417be2e2cea9dcc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47fc5b5e6bb06cf1e0e152f47a4cf5676874206be8c6950dc92370274c300ef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e9bb134cc3f9d6e85c6165c6f942e8ec532a96a1d1dd7f329fdcbd5fa1eae21"
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
