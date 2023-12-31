class Numbat < Formula
  desc "Statically typed programming language for scientific computations"
  homepage "https://github.com/sharkdp/numbat"
  url "https://github.com/sharkdp/numbat/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "5a0435bf938d6166c5089106cfb39049b0b207dec69a96552ccc3f114d515fd9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/numbat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6645d94e88d8ab4840d57797d905a8223d61cf035f5cf136ff9de89448476d37"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d59741688b1a59c0b1033df6611ebd8a7bc8e815b09714a3934d481e572f1623"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a47afbd66695a4f379811fc96c02497529821f111902d2ce8411a5fb9653be2"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc490fc02cec78750565c3060170811046c93f57b7363069fa88be6c3213c172"
    sha256 cellar: :any_skip_relocation, ventura:        "6b8da7a773899db9cb434387e186ba77a27da12a50f71b28bf0af85c8dea2857"
    sha256 cellar: :any_skip_relocation, monterey:       "bc76167236b9c22183d4b9b05ae77a1e6f998dcfe28c1edb0e1bc630fb292b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f1c0a6a893665815e4f692b17b45fc5d2348725c9b95feb4c7dfafc5707fc07"
  end

  depends_on "rust" => :build

  def install
    ENV["NUMBAT_SYSTEM_MODULE_PATH"] = "#{pkgshare}/modules"
    system "cargo", "install", *std_cargo_args(path: "numbat-cli")

    pkgshare.install "numbat/modules"
  end

  test do
    (testpath/"test.nbt").write <<~EOS
      print("pi = {pi}")
    EOS

    output = shell_output("#{bin}/numbat test.nbt")

    assert_equal "pi = 3.14159", output.chomp
  end
end
