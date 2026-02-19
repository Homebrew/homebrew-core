class Katana < Formula
  desc "Crawling and spidering framework"
  homepage "https://github.com/projectdiscovery/katana"
  url "https://github.com/projectdiscovery/katana/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "707d355be6a288a96262197a2ed28f041d789f4cda8463637954e4a9fb0830ce"
  license "MIT"
  head "https://github.com/projectdiscovery/katana.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07698689720828c1e3e486f3cb1ea60521c7e9dcf0bf89ba9c0fbaa8a3d1bd10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "755c6ef7d8920aa7fc767cd4d710d3e3a4f4043962ae43859073b8167f329cdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbfb395c8681d88dcc8aafd24517bbc1bca568fe1f528c9399f8f44199a8c159"
    sha256 cellar: :any_skip_relocation, sonoma:        "d32d4fa493fe8d4564bb74224a208677efd322d7410bbeb4bd07c3541f8539e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2248ad149e4e23be064480b29168237386c0d799a1380d9be1ba495d0037cb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22e87001d78e97c78c790a94396b7660c4051853f1a2d99cca36c548d0b7dd09"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/katana"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/katana -version 2>&1")
    assert_match "Started standard crawling", shell_output("#{bin}/katana -u 127.0.0.1 2>&1")
  end
end
