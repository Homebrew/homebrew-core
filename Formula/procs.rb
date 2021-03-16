class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.11.4.tar.gz"
  sha256 "30a903374eb888b89cd43bbc19365aa24ef01b3588298ab246085dbe42c8e819"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "197d9df98f18130c417b90864018e382c5b2237890bec9283a7a4cff57c4383b"
    sha256 cellar: :any_skip_relocation, big_sur:       "44c7ab94d61b0046b581dd89d1c4cca542212a1a3b97c3192463e03692472387"
    sha256 cellar: :any_skip_relocation, catalina:      "922ae4411101a6edf61a87d40d581847bef955865285dd319b37de975be534c4"
    sha256 cellar: :any_skip_relocation, mojave:        "920049d40859ca273f310813ec77514e92b79c05c042151708820b72e12f16de"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end
