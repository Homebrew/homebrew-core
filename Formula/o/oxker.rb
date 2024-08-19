class Oxker < Formula
  desc "Terminal User Interface (TUI) to view & control docker containers"
  homepage "https://github.com/mrjackwills/oxker"
  url "https://github.com/mrjackwills/oxker/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "082c152e31fb0c0f0adfa60780480d756c4589649963b6616599ab696b7989b4"
  license "MIT"
  head "https://github.com/mrjackwills/oxker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8e66922361ebe2580351259add23543f0fbd9e43e901910b839e2bae11cc4df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a81e79246f1f1686193ed3cc24a0ff30531622111b4a077c596b81a6aa4d4063"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3b20db9ccb3096eb005b38606038de02530959da9fdcfceaffbbb9f5668ef96"
    sha256 cellar: :any_skip_relocation, sonoma:         "fccb5a408e1ca6546326af3190197ce7d656445c060e93ab6ab630061378039a"
    sha256 cellar: :any_skip_relocation, ventura:        "b8015560ed07f3f1b2415ac1cf91b6a8d8002d7e8e28dd87a997e4e0b772ff1f"
    sha256 cellar: :any_skip_relocation, monterey:       "ae0daf2edeb3a7d50c66faa9beeeb69f1ffcd96566ddf23db5fc246e6f237eaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c221292a1826594e214cea97c6471d9a41f39489181cd359c29af4361c40eb3d"
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
