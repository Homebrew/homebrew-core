class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "2beb733fb2b6c3490545b98d4abeab87004a501f0bcfb03751f9e7115c1b81f4"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9721babf91fa2e5bb65925db7fad2f89f2805a318ec9f694df6369309bd08817"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "807e6d1b11996887065f021aa6e01585303408164fb00a8305b1c5d42b861cb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2205e83e399e00de58eb09e05080292769c8bbc635cc51b9b834167cbbdfe61f"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9ab6481a0115d8d9d131ee6260b50d272b3dd169977ca85f8f89a4ce81f3070"
    sha256 cellar: :any_skip_relocation, ventura:        "ad38de2269366cfa12641590731da47b89b5f7c8112d47adea548dcd6794514d"
    sha256 cellar: :any_skip_relocation, monterey:       "d681f6d4f9c5a3a25773aa3b1cf098f6b6f3a1efb82388f8e9a835690bcd0217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a45979044029bf0fbe74e6e54d2483bd5c518f1e85ff631c10749d5c256a0fa"
  end

  depends_on "cmake" => :build # for aws-lc-sys
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 1 responses"
    assert_match output.to_s, shell_output("#{bin}/oha -n 1 -c 1 --no-tui https://www.google.com")

    assert_match version.to_s, shell_output("#{bin}/oha --version")
  end
end
