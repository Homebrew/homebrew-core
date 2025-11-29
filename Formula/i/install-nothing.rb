class InstallNothing < Formula
  desc "Simulates installing things but doesn't actually install anything"
  homepage "https://github.com/buyukakyuz/install-nothing"
  url "https://github.com/buyukakyuz/install-nothing/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "1d4f6536d1ccb1cd0ec30d3ccb8c72b732bdcce14cdf8d48d6bab8482e7c9269"
  license "MIT"
  head "https://github.com/buyukakyuz/install-nothing.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d05581638eafddfc56a2f41180715f34dfb094bb799aa2525094521527a6c013"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fb99f8d2b3accab51ab063f0b5b9fdfb364f1af4e961ce17bd9f0d2593c5f2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef7519bbe3818011a65dd4a7cdcaf3901f66a54d19bfc1d83e360fb93791d69a"
    sha256 cellar: :any_skip_relocation, sonoma:        "940ec025c1db211ad1349fec32491779ab3093e83e21b41f64b6c5118c6783f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7ed94bce128d4cc351bda6209635c5bb35471d8717476a0b28738aa37049d7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cec6899a862fff009024a70964069c35fcbbf52d652b712cd8fee199f446e8e3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # install-nothing is a TUI application
    assert_match version.to_s, shell_output("#{bin}/install-nothing --version")
  end
end
