class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/PRQL/prql/archive/refs/tags/0.12.0.tar.gz"
  sha256 "51caf0dd1d19175c202b50e0bd87541d10f8ccff572797179982022008b66248"
  license "Apache-2.0"
  head "https://github.com/prql/prql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc3d8ff512c85d451a0d8edfe7b60925f2a689edf0f206ec68cea29dfd9ad351"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd2ed4c1e98dfd738037be689caaa76a84697237f9e984cfa39aefee61dbb94d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9a4dc78fa42c3d049ed19c0d4d97b01cf87b0c6a601a3eb5a49285d5201d879"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f027b4b21e425bd8e06495a838d7705f36bc24be20ae2a051d26eaf293886db"
    sha256 cellar: :any_skip_relocation, ventura:        "5eecc78c4a45786d64c644afb2ebad44c28048e46c207a45cc98b05e4f7efb0b"
    sha256 cellar: :any_skip_relocation, monterey:       "702357e22d6bb306cd7174b542a3ff3e7dc4e1f3abacee41ba4540ec56cba016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ef78e277f69a7348207a10b13b81b4c8fe7eb62d052a10b148fb7628cb30de8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prqlc/prqlc")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end
