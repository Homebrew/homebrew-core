class Nping < Formula
  desc "Ping Tool in Rust with Real-Time Data and Visualizations"
  homepage "https://github.com/hanshuaikang/Nping"
  url "https://github.com/hanshuaikang/Nping/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "0ba70f55fc126445b8c57be234c2eb355939336c731c8209b320bd89b85cac50"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "154efe4e2a7876ef5f07f75bee5a1d9430902095cab62374556b049be064f0d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20862eab2cbcfc10caf8e4727406345b8c0963da8d9b11cf77e1e8b481bfdbf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8c8a3c70304a5d2f9ef2d989964bed57ebc73eb522cc47d8f339d1674f03e4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "976671ce122a9ce7f2b835acd39c58299ddf25e5fa6ec331160c68ff37b27a1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "15dbbd76c07db6df865281ae35576d399a582036d66398d07d421723a782bde1"
    sha256 cellar: :any_skip_relocation, ventura:       "7c5caf7fd5802813ed2ddf22dd8aaf9cf7fe52d5eb4190c36e150653326deb02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa83bd35615c2d4dc74e7715bf0344fd514cc0f4c7dabbb554b27ad9b4de44d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f43a159b169eb801516e3b670ebb243636e3962437de4daa39d2a1cbb2da67c"
  end

  depends_on "rust" => :build

  conflicts_with "nmap", because: "both install `nping` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "nping v#{version}", shell_output("#{bin}/nping --version")

    # Fails in Linux CI with "No such device or address (os error 2)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"nping", "--count", "2", "brew.sh"
  end
end
