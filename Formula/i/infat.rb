class Infat < Formula
  desc "Tool to set default openers for file formats and url schemes on MacOS"
  homepage "https://github.com/philocalyst/infat"
  url "https://github.com/philocalyst/infat/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "d07e1331d8afc54302c09e35c392255be8484d4fc1c30a953190e892115253a2"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f46fdc6180bb8b686097fd882637447a83dbe05067cb73ed5455b75b382aecb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54a73c2c23dd9a21eaeb9f996617dfc5722b1c112e392d10bbd9105c889b652c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "658fe1a3fb17b91952dd51b320fb531704b73d923cf7525e740f29ba06c1e5e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1338457b9a58c1f664384ea4bee06ee72b3a34ea1eb8e4d1922751365fc48ca"
    sha256 cellar: :any_skip_relocation, ventura:       "e8badab073016a3671fbe30d827926955802cf501362ee221db13b082fd60dc7"
  end

  depends_on :macos
  uses_from_macos "swift" => :build

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--static-swift-stdlib"
    bin.install ".build/release/infat"

    generate_completions_from_executable(bin/"infat", "--generate-completion-script")
  end

  test do
    output = shell_output("#{bin}/infat set TextEdit --ext txt")
    assert_match "Successfully bound TextEdit to txt", output
  end
end
