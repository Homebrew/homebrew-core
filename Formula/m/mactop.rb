class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Go Lang"
  homepage "https://github.com/metaspartan/mactop"
  url "https://github.com/metaspartan/mactop/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "afe31e876841d7362d3514e5aa927587adc0d351d88fa3df165619cc8c680a2a"
  license "MIT"
  head "https://github.com/metaspartan/mactop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e883acda3840ae8d107c931f54d56250666d016d9f8ecc6b59b38306c2589440"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "946bb00996c49b882d39c906f167f8b91fc14b01f7ba628248fe37972ced595e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db008db6910a0fdb0a821d12e21bb4a7ebf0bc46d86ef98ca5e53b0ea60b65cf"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    test_input = "This is a test input for brew"
    assert_match "Test input received: #{test_input}", shell_output("#{bin}/mactop --test '#{test_input}'")
  end
end
