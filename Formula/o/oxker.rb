class Oxker < Formula
  desc "Terminal User Interface (TUI) to view & control docker containers"
  homepage "https://github.com/mrjackwills/oxker"
  url "https://github.com/mrjackwills/oxker/archive/refs/tags/v0.10.5.tar.gz"
  sha256 "d8c79a1732320d84d149b0db892f3875a6513c7c36b05b4c37d22dfebdf5dee0"
  license "MIT"
  head "https://github.com/mrjackwills/oxker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6bbdfda2462128afbb22b9d2f2339fcde3755c33adeb401b01e5ad5921644f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee21610c29540759038ff8f31f3dd11c809c6e2784644125432b76d53ed8a940"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "771e84d6fe6dce8c77e96f2595f4f62b5cb29b8876b8b6c54d66fb92478e2bc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c073241a7b1eca4bb481952924c4af1014882d7a0f191bdc52e12aa4352ab908"
    sha256 cellar: :any_skip_relocation, ventura:       "0e3f8baba042ec37a564da20f07d36610c0cdb0f07b813ba01c4d5d101ee5533"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f45e11a6f1f5659d325e63ae33c85a5b625f25e7abc66255924eed8cb68b9ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9f56e0e566f6adf60002c2ae8601ee988e76c7448519d707f5db4638990a486"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output(bin/"oxker --version")

    assert_match "a value is required for '--host <HOST>' but none was supplied",
      shell_output(bin/"oxker --host 2>&1", 2)
  end
end
