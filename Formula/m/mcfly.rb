class Mcfly < Formula
  desc "Fly through your shell history"
  homepage "https://github.com/cantino/mcfly"
  url "https://github.com/cantino/mcfly/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "ac292c65a0cf031d583961b3bb3a93156fc0c8247dfa9aec0a35c786a25d23da"
  license "MIT"
  head "https://github.com/cantino/mcfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5fc2c5e242ee47b24e6958d3e679f7c99e52d5f07905c85bddc1227661c2a59c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a4a5ca3013af401ae23eb044f462bc24c6c69dee7ae7bc2b5290bb52e982e99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ce862f2b801081f4869551ca3003584efaebc71e811077318d0d76acca4b9d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "625889cc11904dd7e467da585d5f1f1af17bbda433f957e48e85c703c62435a2"
    sha256 cellar: :any_skip_relocation, ventura:        "598177d8ef77ffc767ea3480cc143d7006e34a03a93534425db087b5f5139b1a"
    sha256 cellar: :any_skip_relocation, monterey:       "d0b4e29000c4275e910c4d1cc1279a0f6872ab98f67102bacf069197a9c11f4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f868b4c5d368d56d728754602ec005b4099d7256d882b8324193664d3cceac9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "mcfly_prompt_command", shell_output("#{bin}/mcfly init bash")
    assert_match version.to_s, shell_output("#{bin}/mcfly --version")
  end
end
