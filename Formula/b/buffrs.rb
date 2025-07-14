class Buffrs < Formula
  desc "Modern protobuf package management"
  homepage "https://github.com/helsing-ai/buffrs"
  url "https://github.com/helsing-ai/buffrs/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "c52b04ef9d7919d19d9c3fd6312091f0000a65097e55c45c6f9f3ab5d2d3369c"
  license "Apache-2.0"
  head "https://github.com/helsing-ai/buffrs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b48db1d0f92f5ea602daa0ee3f1144ec731b5b698f796d14e3b6c1e3713d07eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4f91126c4f5858b219cfbc77dd0387ef34ac4ceacca9bfa7c2f5ff6f949476b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "01be1c3a392d1f3eccbd5b0f9192bd05eec93970df920cc91eb1e7eae45517e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cfeeaab827d991b4cad11b9dda4bec5a945c6e0739fc66368eca0de765819f5"
    sha256 cellar: :any_skip_relocation, ventura:       "3a64c41d00df7a7a1a723862395111bd453f0e53db547a0b0eccc96bf8da2de1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24e12ab2178b05497cb35720450c8c5a3efc42b8566834c0718bbe7ed5ff4e22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4206df7cccc9918528f8a93193ea5c0ba4e2ab25cc16d579b975c201b13bcba0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/buffrs --version")

    system bin/"buffrs", "init"
    assert_match "edition = \"#{version.major_minor}\"", (testpath/"Proto.toml").read

    assert_empty shell_output("#{bin}/buffrs list")
  end
end
