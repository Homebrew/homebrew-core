class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "4661bebc010209c5c3d180a8f7ad6c16b596655acf74bf459d3baf81af8589d5"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "405a9b9ba544e34de5bfa28d894f0e79c1c78a4bf98b178e31ab25970df01fd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d854103c68b3fb28140aa6dd42ac74cea9768e63f3a34b88598c1f774e5de8c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1bf695135d21df76cc771b97b32fdc28823854123c7fdc09d63c47134e8dd6f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc3f2fca62b3732bf983b957780b8f52c0bec7301e678ab31332b671e7177de7"
    sha256 cellar: :any_skip_relocation, ventura:       "000ec3329cb534593c4fd660a78eab1eb477dec98070c930ab169596cd68052e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e193b2135cc03984260839f0dea8bb148d8aaef4a2e3a8fc596275b3e418f7ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98a6a74f866139deb8296ea9b46987d833c378483e264ee68085b7355b000772"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  def install
    system "cargo", "install", *std_cargo_args(path: "gleam-bin")
  end

  test do
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system bin/"gleam", "test"
  end
end
