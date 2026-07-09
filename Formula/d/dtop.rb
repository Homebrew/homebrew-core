class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://github.com/amir20/dtop/archive/refs/tags/v0.7.8.tar.gz"
  sha256 "53c30ea858ff27fa6e6438790d17697b4261bd5145f87bd17342309194cdea36"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04e3c2039ae02ef5bea908dd6cbc545d408c405382c94615e03f1c2575fe38f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f7e5a8819d6e8577fb74a324730da6bab6a5b0f1b59a06f9d5dae6d5fad677e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8bf3650e109c9919b8090b8cf70047e642ee14f92e99e7090e0a35eed96ecfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "5428a1c81070f624c5c4b5ea05aadd4a2b18d26155995b77fb823f73786b3c9f"
    sha256 cellar: :any,                 arm64_linux:   "572c291ad536631312762879ea76f7757913853f15de12529a8f63a9a00ebd57"
    sha256 cellar: :any,                 x86_64_linux:  "c7a2d8e510764ebfbcc38185d296f76c171fcb8d95228274060461712ae711c6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dtop --version")

    output = shell_output("#{bin}/dtop 2>&1", 1)
    assert_match "Failed to connect to Docker host", output
  end
end
